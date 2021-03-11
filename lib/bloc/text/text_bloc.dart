import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/bloc/text/text_events.dart';
import 'package:notable/entity/entity.dart';
import 'package:notable/model/label.dart';
import 'package:notable/model/text_note.dart';

import 'text_states.dart';

class TextNoteBloc extends Bloc<TextNoteEvent, TextNoteState> {
  final NotesBloc<TextNote, TextNoteEntity> notesBloc;
  final String id;

  StreamSubscription _textNotesSubscription;

  TextNoteBloc({@required this.notesBloc, @required this.id})
      : super(_initialState(notesBloc, id)) {
    _textNotesSubscription = notesBloc.listen((state) {
      if (state is NotesLoaded && id != null) {
        add(LoadTextNote(state.notes.findForId(id)));
      }
    });
  }

  @override
  Future<void> close() {
    _textNotesSubscription.cancel();
    return super.close();
  }

  static TextNoteState _initialState(
      NotesBloc<TextNote, TextNoteEntity> notesBloc, String id) {
    if (id == null) {
      return TextNoteLoaded(TextNote((b) => b
        ..title = ''
        ..text = ''
        ..labels = ListBuilder<Label>()));
    } else if (notesBloc.state is NotesLoaded) {
      return TextNoteLoaded(
          (notesBloc.state as NotesLoaded).notes.findForId(id));
    } else {
      return TextNoteLoading();
    }
  }

  @override
  Stream<TextNoteState> mapEventToState(TextNoteEvent event) async* {
    if (event is LoadTextNote) {
      yield* _mapLoadTextNoteEventToState(state, event);
    } else if (event is SaveTextNote) {
      yield* _mapSaveTextNoteEventToState(state, event);
    } else if (event is DeleteTextNote) {
      yield* _mapDeleteTextNoteEventToState(state, event);
    } else if (event is UpdateTextNoteTitle) {
      yield* _mapUpdateTextNoteTitleEventToState(state, event);
    } else if (event is UpdateTextNoteText) {
      yield* _mapUpdateTextNoteTextEventToState(state, event);
    }
  }

  Stream<TextNoteState> _mapLoadTextNoteEventToState(
      TextNoteState currentState, LoadTextNote event) async* {
    yield TextNoteLoaded(event.textNote);
  }

  Stream<TextNoteState> _mapSaveTextNoteEventToState(
      TextNoteState currentState, TextNoteEvent event) async* {
    if (currentState is TextNoteLoaded) {
      _saveTextNote(currentState.textNote);
    }
  }

  void _saveTextNote(TextNote textNote) {
    if (id == null) {
      notesBloc.add(AddNote(textNote));
    } else {
      notesBloc.add(UpdateNote(textNote));
    }
  }

  Stream<TextNoteState> _mapDeleteTextNoteEventToState(
      TextNoteState currentState, TextNoteEvent event) async* {
    assert(id != null);

    // Delete the note and return all the notes
    notesBloc.add(DeleteNote(id));
  }

  Stream<TextNoteState> _mapUpdateTextNoteTitleEventToState(
      TextNoteState currentState, UpdateTextNoteTitle event) async* {
    if (currentState is TextNoteLoaded) {
      var updatedTextNote =
          currentState.textNote.rebuild((b) => b..title = event.title);
      yield TextNoteLoaded(updatedTextNote);
    }
  }

  Stream<TextNoteState> _mapUpdateTextNoteTextEventToState(
      TextNoteState currentState, UpdateTextNoteText event) async* {
    if (currentState is TextNoteLoaded) {
      var updatedTextNote =
          currentState.textNote.rebuild((b) => b..text = event.text);
      yield TextNoteLoaded(updatedTextNote);
    }
  }
}
