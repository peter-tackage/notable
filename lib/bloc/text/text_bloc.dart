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

  TextNoteBloc({@required this.notesBloc, @required this.id}) {
    _textNotesSubscription = notesBloc.state.listen((state) {
      if (state is NotesLoaded) {
        dispatch(
            LoadTextNote(state.notes.firstWhere((note) => note.id == this.id,
                orElse: () => TextNote((b) => b
                  ..title = ''
                  ..text = ''
                  ..labels = ListBuilder<Label>())) as TextNote));
      }
    });
  }

  @override
  TextNoteState get initialState => TextNoteLoading();

  @override
  Stream<TextNoteState> mapEventToState(TextNoteEvent event) async* {
    if (event is LoadTextNote) {
      yield* _mapLoadTextNoteEventToState(currentState, event);
    } else if (event is SaveTextNote) {
      yield* _mapSaveTextNoteEventToState(currentState, event);
    } else if (event is DeleteTextNote) {
      yield* _mapDeleteTextNoteEventToState(currentState, event);
    } else if (event is UpdateTextNoteTitle) {
      yield* _mapUpdateTextNoteTitleEventToState(currentState, event);
    } else if (event is UpdateTextNoteText) {
      yield* _mapUpdateTextNoteTextEventToState(currentState, event);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _textNotesSubscription.cancel();
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
      notesBloc.dispatch(AddNote(textNote));
    } else {
      notesBloc.dispatch(UpdateNote(textNote));
    }
  }

  Stream<TextNoteState> _mapDeleteTextNoteEventToState(
      TextNoteState currentState, TextNoteEvent event) async* {
    assert(id != null);

    // Delete the note and return all the notes
    notesBloc.dispatch(DeleteNote(id));
  }

  Stream<TextNoteState> _mapUpdateTextNoteTitleEventToState(
      TextNoteState currentState, UpdateTextNoteTitle event) async* {
    if (currentState is TextNoteLoaded) {
      TextNote updatedTextNote =
          currentState.textNote.rebuild((b) => b..title = event.title);
      yield TextNoteLoaded(updatedTextNote);
    }
  }

  Stream<TextNoteState> _mapUpdateTextNoteTextEventToState(
      TextNoteState currentState, UpdateTextNoteText event) async* {
    if (currentState is TextNoteLoaded) {
      TextNote updatedTextNote =
          currentState.textNote.rebuild((b) => b..text = event.text);
      yield TextNoteLoaded(updatedTextNote);
    }
  }
}
