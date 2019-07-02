import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:meta/meta.dart';
import 'package:notable/bloc/audio/audio_events.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/entity/audio_note_entity.dart';
import 'package:notable/entity/base_note_entity.dart';
import 'package:notable/model/audio_note.dart';
import 'package:notable/model/audio_playback.dart';
import 'package:notable/model/audio_recording.dart';
import 'package:notable/model/base_note.dart';
import 'package:notable/model/label.dart';
import 'package:notable/storage/sound_storage.dart';

import 'audio_states.dart';

class AudioNoteBloc<M extends BaseNote, E extends BaseNoteEntity>
    extends Bloc<AudioNoteEvent, AudioNoteState> {
  final NotesBloc<AudioNote, AudioNoteEntity> notesBloc;
  final String id;
  final FlutterSound flutterSound;
  final SoundStorage soundStorage;

  StreamSubscription _audioNotesSubscription;
  StreamSubscription _recorderSubscription;
  StreamSubscription _dbPeakSubscription;
  StreamSubscription _playbackSubscription;

  AudioNoteBloc(
      {@required this.notesBloc,
      @required this.id,
      @required this.flutterSound,
      @required this.soundStorage}) {
    _audioNotesSubscription = notesBloc.state.listen((state) {
      if (state is NotesLoaded) {
        dispatch(
            LoadAudioNote(state.notes.firstWhere((note) => note.id == this.id,
                orElse: () => AudioNote((b) => b
                  ..filename = null
                  ..lengthMillis = 0
                  ..title = ''
                  ..labels = ListBuilder<Label>())) as AudioNote));
      }
    });
  }

  @override
  AudioNoteState get initialState => AudioNoteLoading();

  @override
  Stream<AudioNoteState> mapEventToState(AudioNoteEvent event) async* {
    if (event is LoadAudioNote) {
      yield* _mapLoadAudioNoteEventToState(currentState, event);
    } else if (event is SaveAudioNote) {
      yield* _mapSaveAudioNoteEventToState(currentState, event);
    } else if (event is DeleteAudioNote) {
      yield* _mapDeleteAudioNoteEventToState(currentState, event);
    } else if (event is ClearAudioNote) {
      yield* _mapClearAudioNoteEventToState(currentState, event);

      // TODO Maybe move these to a playback Bloc
    } else if (event is StartAudioRecordingRequest) {
      yield* _mapStartAudioRecordingEventToState(currentState, event);
    } else if (event is StopAudioRecordingRequest) {
      yield* _mapStopAudioRecordingEventToState(currentState, event);
    } else if (event is StartAudioPlaybackRequest) {
      yield* _mapStartAudioPlaybackEventToState(currentState, event);
    } else if (event is PauseAudioPlaybackRequest) {
      yield* _mapPauseAudioPlaybackEventToState(currentState, event);
    } else if (event is ResumeAudioPlaybackRequest) {
      yield* _mapResumeAudioPlaybackEventToState(currentState, event);
    } else if (event is StopAudioPlaybackRequest) {
      yield* _mapStopAudioPlaybackEventToState(currentState, event);
    } else if (event is AudioPlaybackProgressChanged) {
      yield* _mapAudioPlaybackProgressChangedEventToState(currentState, event);
    } else if (event is AudioRecordingProgressChanged) {
      yield* _mapAudioRecordingProgressChangedEventToState(currentState, event);
    } else if (event is AudioRecordingLevelChanged) {
      yield* _mapAudioRecordingLevelChangedEventToState(currentState, event);
    } else if (event is UpdateAudioNoteTitle) {
      yield* _mapUpdateAudioNoteTitleEventToState(currentState, event);
    }
  }

  @override
  void dispose() {
    super.dispose();

    _audioNotesSubscription.cancel();
    _recorderSubscription?.cancel();
    _dbPeakSubscription?.cancel();
    _playbackSubscription?.cancel();

    // Stop the recording/playback.
    _stopAudioEngine();

    //
    // TODO Do we have enough information to delete here - will the id be set in time?
    // We don't know what action prompted this (save/back), so we can't delete the recording here.
    //
    // Probably not, because the pop happens synchronously and the dispatch is asynchronous.
    //

    if (currentState is AudioNoteLoaded &&
        (currentState as AudioNoteLoaded).audioNote.id == null) {
      print("Deleting note recording without id");
    }
  }

  Stream<AudioNoteState> _mapLoadAudioNoteEventToState(
      AudioNoteState currentState, LoadAudioNote event) async* {
    yield AudioNoteLoaded(event.audioNote);
  }

  Stream<AudioNoteState> _mapSaveAudioNoteEventToState(
      AudioNoteState currentState, AudioNoteEvent event) async* {
    // Smart cast only works with local variables and parameters.
    final AudioNoteState noteState = currentState;
    if (noteState is AudioNoteLoaded) _updateAudioNote(noteState.audioNote);
    if (noteState is AudioNotePlayback) _updateAudioNote(noteState.audioNote);
  }

  void _updateAudioNote(AudioNote audioNote) {
    print(
        "Looking to save audio note id: ${audioNote.id} filename: ${audioNote.filename}");

    if (id == null) {
      notesBloc.dispatch(AddNote(audioNote));
    } else {
      notesBloc.dispatch(UpdateNote(audioNote));
    }
  }

  Stream<AudioNoteState> _mapDeleteAudioNoteEventToState(
      AudioNoteState currentState, AudioNoteEvent event) async* {
    assert(id != null);

    // Stop the audio engine
    _stopAudioEngine();

    // Delete the audio file
    if (currentState is BaseAudioNoteLoaded) {
      soundStorage.delete(currentState.audioNote.filename);
    }

    // Delete the note and return all the notes
    notesBloc.dispatch(DeleteNote(id));
  }

  Stream<AudioNoteState> _mapClearAudioNoteEventToState(
      AudioNoteState currentState, ClearAudioNote event) async* {
    if (currentState is BaseAudioNoteLoaded) {
      // TODO yield - delete the actual recording (not the note)
    }
  }

  Stream<AudioNoteState> _mapStartAudioRecordingEventToState(
      AudioNoteState currentState, StartAudioRecordingRequest event) async* {
    assert(flutterSound.isPlaying == false);
    assert(flutterSound.isRecording == false);

    print("Attempting to record");
    // IMPORTANT: You're not allowed to record saved notes, only unsaved notes.
    if (currentState is AudioNoteLoaded && currentState.audioNote.id == null) {
      print("More like it");
      // Cancel existing
      _recorderSubscription?.cancel();
      _dbPeakSubscription?.cancel();

      // First time for an unsaved note, we need to set the filename.
      final filename = currentState.audioNote.filename ??
          await soundStorage.generateFilename();

      // Start new recording to a newly generated filename
      await flutterSound.startRecorder(filename);

      // Initial event
      yield AudioNoteRecording(
          currentState.audioNote.rebuild((b) => b..filename = filename),
          AudioRecording((b) => b
            ..recordingState = RecordingState.Recording
            ..level = 0
            ..progress = 0));

      // Send updates to self
      _recorderSubscription = flutterSound.onRecorderStateChanged.listen((e) {
        dispatch(AudioRecordingProgressChanged(
            flutterSound.isRecording, e?.currentPosition));
      });

      _dbPeakSubscription =
          flutterSound.onRecorderDbPeakChanged.listen((value) {
        dispatch(AudioRecordingLevelChanged(value));
      });
    }
  }

  Stream<AudioNoteState> _mapStopAudioRecordingEventToState(
      AudioNoteState currentState, StopAudioRecordingRequest event) async* {
    assert(flutterSound.isPlaying == false);
    assert(flutterSound.isRecording == true);

    if (currentState is AudioNoteRecording) {
      _recorderSubscription?.cancel();
      _dbPeakSubscription?.cancel();

      // Stop recording
      await flutterSound.stopRecorder();

      yield AudioNoteLoaded(currentState.audioNote.rebuild(
          (b) => b..lengthMillis = currentState.audioRecording.progress));
    }
  }

  Stream<AudioNoteState> _mapAudioRecordingProgressChangedEventToState(
      AudioNoteState currentState, AudioRecordingProgressChanged event) async* {
    if (currentState is AudioNoteRecording) {
      // NOTE: Because pausing recording is not supported by the current library,
      // we transition directly from isRecording = true to the AudioNoteLoadedState

      if (event.isRecording) {
        yield AudioNoteRecording(
            currentState.audioNote,
            currentState.audioRecording.rebuild((b) => b
              ..recordingState = RecordingState.Recording
              ..progress = event.progress ?? 0));
      } else {
        yield AudioNoteLoaded(currentState.audioNote);
      }
    }
  }

  Stream<AudioNoteState> _mapAudioRecordingLevelChangedEventToState(
      AudioNoteState currentState, AudioRecordingLevelChanged event) async* {
    if (currentState is AudioNoteRecording) {
      yield AudioNoteRecording(
          currentState.audioNote,
          currentState.audioRecording
              .rebuild((b) => b..level = event.level ?? 0));
    }
  }

  Stream<AudioNoteState> _mapStartAudioPlaybackEventToState(
      AudioNoteState currentState, StartAudioPlaybackRequest event) async* {
    if (currentState is AudioNoteLoaded) {
      _playbackSubscription?.cancel();

      await flutterSound.startPlayer(currentState.audioNote.filename);
      await flutterSound.setVolume(1.0);

      _playbackSubscription = flutterSound.onPlayerStateChanged.listen((e) {
        // null indicates that playback has stopped (EOF).
        e == null
            ? dispatch(StopAudioPlaybackRequest())
            : dispatch(AudioPlaybackProgressChanged(
                flutterSound.isPlaying, e?.currentPosition));
      });

      yield AudioNotePlayback(
          currentState.audioNote,
          AudioPlayback((b) => b
            ..playbackState = PlaybackState.Playing
            ..progress = 0
            ..volume = 0));
    }
  }

  Stream<AudioNoteState> _mapStopAudioPlaybackEventToState(
      AudioNoteState currentState, StopAudioPlaybackRequest event) async* {
    if (currentState is AudioNotePlayback) {
      // When the audio clip reaches EOF, we don't need to tell the player to stop.
      if (flutterSound.isPlaying) {
        await flutterSound.stopPlayer();
      }

      _playbackSubscription?.cancel();

      yield AudioNoteLoaded(currentState.audioNote);
    }
  }

  Stream<AudioNoteState> _mapPauseAudioPlaybackEventToState(
      AudioNoteState currentState, PauseAudioPlaybackRequest event) async* {
    if (currentState is AudioNotePlayback) {
      await flutterSound.pausePlayer();

      yield AudioNotePlayback(
          currentState.audioNote,
          currentState.audioPlayback
              .rebuild((b) => b..playbackState = PlaybackState.Paused));
    }
  }

  Stream<AudioNoteState> _mapResumeAudioPlaybackEventToState(
      AudioNoteState currentState, ResumeAudioPlaybackRequest event) async* {
    if (currentState is AudioNotePlayback) {
      await flutterSound.resumePlayer();

      yield AudioNotePlayback(
          currentState.audioNote,
          currentState.audioPlayback
              .rebuild((b) => b..playbackState = PlaybackState.Playing));
    }
  }

  Stream<AudioNoteState> _mapAudioPlaybackProgressChangedEventToState(
      AudioNoteState currentState, AudioPlaybackProgressChanged event) async* {
    if (currentState is AudioNotePlayback) {
      // We have the ability to pause playback
      yield AudioNotePlayback(
          currentState.audioNote,
          currentState.audioPlayback.rebuild((b) => b
            ..playbackState = PlaybackState.Playing
            ..progress = event.progress ?? 0));
    }
  }

  Stream<AudioNoteState> _mapUpdateAudioNoteTitleEventToState(
      AudioNoteState currentState, UpdateAudioNoteTitle event) async* {
    // Can only update the title when the recorder/player is idle.
    // Otherwise it gets too fiddly to check which is the current state
    // and then modify the field.
    if (currentState is AudioNoteLoaded) {
      AudioNote updatedAudioNote =
          currentState.audioNote.rebuild((b) => b..title = event.title);
      yield AudioNoteLoaded(updatedAudioNote);
    }
  }

  void _stopAudioEngine() async {
    print(
        "stopAudioEngine: ${flutterSound.isPlaying} / ${flutterSound.isRecording}");
    if (flutterSound.isPlaying) await flutterSound.stopPlayer();
    if (flutterSound.isRecording) await flutterSound.stopRecorder();
  }
}
