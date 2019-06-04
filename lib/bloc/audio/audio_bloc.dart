import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:meta/meta.dart';
import 'package:notable/bloc/audio/audio_events.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/entity/audio_note_entity.dart';
import 'package:notable/entity/base_note_entity.dart';
import 'package:notable/model/audio_note.dart';
import 'package:notable/model/audio_recording.dart';
import 'package:notable/model/base_note.dart';
import 'package:notable/model/label.dart';

import 'audio_states.dart';

class AudioNoteBloc<M extends BaseNote, E extends BaseNoteEntity>
    extends Bloc<AudioNoteEvent, AudioNoteState> {
  final NotesBloc<AudioNote, AudioNoteEntity> notesBloc;
  final String id;
  final FlutterSound flutterSound;

  StreamSubscription _audioNotesSubscription;
  StreamSubscription _recorderSubscription;
  StreamSubscription _dbPeakSubscription;

  AudioNoteBloc(
      {@required this.notesBloc,
      @required this.id,
      @required this.flutterSound}) {
    _audioNotesSubscription = notesBloc.state.listen((state) {
      if (state is NotesLoaded) {
        dispatch(LoadAudioNote(state.notes.firstWhere(
            (note) => note.id == this.id,
            orElse: () => AudioNote('', List<Label>(), '')) as AudioNote));
      }
    });
  }

  @override
  AudioNoteState get initialState => AudioNoteLoading();

  @override
  Stream<AudioNoteState> mapEventToState(AudioNoteEvent event) async* {
    print("AudioBloc got even: $event");

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
    } else if (event is StopAudioPlaybackRequest) {
      yield* _mapStopAudioPlaybackEventToState(currentState, event);
    } else if (event is AudioRecordingProgressChanged) {
      yield* _mapAudioRecordingProgressChangedEventToState(currentState, event);
    } else if (event is AudioRecordingLevelChanged) {
      yield* _mapAudioRecordingLevelChangedEventToState(currentState, event);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _audioNotesSubscription.cancel();
  }

  Stream<AudioNoteState> _mapLoadAudioNoteEventToState(
      AudioNoteState currentState, LoadAudioNote event) async* {
    yield AudioNoteLoaded(event.audioNote);
  }

  Stream<AudioNoteState> _mapSaveAudioNoteEventToState(
      AudioNoteState currentState, AudioNoteEvent event) async* {
    if (currentState is AudioNoteLoaded) {
      if (id == null) {
        notesBloc.dispatch(AddNote(currentState.audioNote));
      } else {
        notesBloc.dispatch(UpdateNote(currentState.audioNote));
      }
    }
  }

  Stream<AudioNoteState> _mapDeleteAudioNoteEventToState(
      AudioNoteState currentState, AudioNoteEvent event) async* {
    assert(id != null);

    // Delete the note and return all the notes
    notesBloc.dispatch(DeleteNote(id));
  }

  Stream<AudioNoteState> _mapClearAudioNoteEventToState(
      AudioNoteState currentState, ClearAudioNote event) async* {
    if (currentState is AudioNoteLoaded) {
      // TODO yield - delete the actual recording (not the note)
    }
  }

  Stream<AudioNoteState> _mapStartAudioRecordingEventToState(
      AudioNoteState currentState, StartAudioRecordingRequest event) async* {
    assert(flutterSound.isPlaying == false);
    assert(flutterSound.isRecording == false);

    if (currentState is AudioNoteLoaded) {
      // Cancel existing
      _recorderSubscription?.cancel();
      _dbPeakSubscription?.cancel();

      // Start new recording
      String path = await flutterSound.startRecorder(null);
      print('startRecorder: $path');

      // Initial event
      yield AudioNoteRecording(currentState.audioNote,
          AudioRecording("defaultfilename", RecordingState.Recording, 0, 0));

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
    // assert(flutterSound.isPlaying == false);
    // assert(flutterSound.isRecording == true);

    if (currentState is AudioNoteRecording) {
      // Start new recording
      String result = await flutterSound.stopRecorder();

      // DO THIS??
//      _recorderSubscription?.cancel();
//      _dbPeakSubscription?.cancel();

    }
  }

  Stream<AudioNoteState> _mapAudioRecordingProgressChangedEventToState(
      AudioNoteState currentState, AudioRecordingProgressChanged event) async* {
    if (currentState is AudioNoteRecording) {
      print("mapping progress: $event");

      yield AudioNoteRecording(
          currentState.audioNote,
          currentState.audioRecording.copyWith(
              recordingState: event.isRecording
                  ? RecordingState.Recording
                  : RecordingState.Idle,
              progress: event.progress));
    }
  }

  Stream<AudioNoteState> _mapAudioRecordingLevelChangedEventToState(
      AudioNoteState currentState, AudioRecordingLevelChanged event) async* {
    if (currentState is AudioNoteRecording) {
      print("mapping level: $event");

      yield AudioNoteRecording(currentState.audioNote,
          currentState.audioRecording.copyWith(level: event.level));
    }
  }

  Stream<AudioNoteState> _mapStartAudioPlaybackEventToState(
      AudioNoteState currentState, StartAudioPlaybackRequest event) async* {}

  Stream<AudioNoteState> _mapStopAudioPlaybackEventToState(
      AudioNoteState currentState, StopAudioPlaybackRequest event) async* {}
}
