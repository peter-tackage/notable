import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:notable/bloc/audio/audio_events.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/entity/audio_note_entity.dart';
import 'package:notable/entity/base_note_entity.dart';
import 'package:notable/model/audio_note.dart';
import 'package:notable/model/base_note.dart';
import 'package:notable/model/label.dart';

import 'audio_states.dart';

class AudioNoteBloc<M extends BaseNote, E extends BaseNoteEntity>
    extends Bloc<AudioNoteEvent, AudioNoteState> {
  final NotesBloc<AudioNote, AudioNoteEntity> notesBloc;
  final String id;

  StreamSubscription audioNotesSubscription;

  AudioNoteBloc({@required this.notesBloc, @required this.id}) {
    audioNotesSubscription = notesBloc.state.listen((state) {
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
    if (event is LoadAudioNote) {
      yield* _mapLoadAudioNoteEventToState(currentState, event);
    } else if (event is SaveAudioNote) {
      yield* _mapSaveAudioNoteEventToState(currentState, event);
    } else if (event is DeleteAudioNote) {
      yield* _mapDeleteAudioNoteEventToState(currentState, event);
    } else if (event is ClearAudioNote) {
      yield* _mapClearAudioNoteEventToState(currentState, event);
    }
  }

  @override
  void dispose() {
    super.dispose();
    audioNotesSubscription.cancel();
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
      // TODO yield
    }
  }
}
