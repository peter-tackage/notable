import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:notable/bloc/checklist/checklist_events.dart';
import 'package:notable/bloc/checklist/checklist_states.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/bloc/notes/notes_states.dart';
import 'package:notable/entity/entity.dart';
import 'package:notable/model/base_note.dart';
import 'package:notable/model/checklist.dart';

class ChecklistBloc extends Bloc<ChecklistEvent, ChecklistState> {
  final NotesBloc<Checklist, ChecklistEntity> notesBloc;
  final String id;

  StreamSubscription checklistsSubscription;

  ChecklistBloc({@required this.notesBloc, @required this.id}) {
    checklistsSubscription = notesBloc.state.listen((state) {
      print("Subscribed to NoteBloc state: $state");
      if (state is NotesLoaded) {
        dispatch(UpdateChecklist(state.notes.firstWhere(
                (note) => note.id == this.id,
                orElse: () => Checklist(
                    '', List<Label>(), [ChecklistItem('', false)].toList()))
            as Checklist));
      }
    });
  }

  @override
  ChecklistState get initialState => ChecklistLoading();

  @override
  Stream<ChecklistState> mapEventToState(ChecklistEvent event) async* {
    print("mapEventToState: $event");

    if (event is LoadChecklist) {
      yield* _mapLoadChecklistEventToState(currentState, event);
    } else if (event is UpdateChecklist) {
      yield* _mapUpdateChecklistEventToState(currentState, event);
    } else if (event is DeleteChecklist) {
      yield* _mapDeleteChecklistEventToState(currentState, event);
    } else if (event is AddChecklistItem) {
      yield* _mapAddChecklistItemEventToState(currentState, event);
    } else if (event is AddEmptyChecklistItem) {
      yield* _mapAddEmptyChecklistItemEventToState(currentState, event);
    }
  }

  Stream<ChecklistState> _mapLoadChecklistEventToState(
      ChecklistState currentState, ChecklistEvent event) async* {
    if (event is LoadChecklist) {
      notesBloc.dispatch(LoadNotes());
    }
  }

  Stream<ChecklistState> _mapUpdateChecklistEventToState(
      ChecklistState currentState, ChecklistEvent event) async* {
    if (event is UpdateChecklist) {
      yield ChecklistLoaded(event.checklist);
    }
  }

//  Stream<NotesState> _mapAddNoteEventToState(
//      NotesState currentState, NotesEvent event) async* {
//    if (event is AddNote) {
//      // Save the note and return all the notes
//      await noteRepository.save(mapper.toEntity(event.note));
//      final notes = await noteRepository.getAll();
//      yield NotesLoaded(_toModels(notes));
//    }
//  }
//
//  Stream<NotesState> _mapUpdateNoteEventToState(
//      NotesState currentState, NotesEvent event) async* {
//    if (event is UpdateNote) {
//      // Save the note and return all the notes
//      await noteRepository.save(mapper.toEntity(event.note));
//      final notes = await noteRepository.getAll();
//      yield NotesLoaded(_toModels(notes));
//    }
//  }
//
  Stream<ChecklistState> _mapDeleteChecklistEventToState(
      ChecklistState currentState, ChecklistEvent event) async* {
    if (event is DeleteChecklist) {
      // Delete the note and return all the notes
      notesBloc.dispatch(DeleteNote(id));
    }
  }

  Stream<ChecklistState> _mapAddChecklistItemEventToState(
      ChecklistState currentState, ChecklistEvent event) async* {
    if (event is AddChecklistItem) {
      // Add the item to existing note
      if (currentState is ChecklistLoaded) {
        currentState.checklist.items.add(event.item);
        yield ChecklistLoaded(currentState.checklist);
      }
    }
  }

  Stream<ChecklistState> _mapAddEmptyChecklistItemEventToState(
      ChecklistState currentState, ChecklistEvent event) async* {
    print("_mapAddEmptyChecklistItemEventToState: $currentState, $event");

    if (event is AddEmptyChecklistItem) {
      // Add the item to existing note
      if (currentState is ChecklistLoaded) {
        List<ChecklistItem> items = currentState.checklist.items;
        items.add(ChecklistItem('', false));
        yield ChecklistLoaded(currentState.checklist.copyWith(items: items));
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    checklistsSubscription.cancel();
  }
}
