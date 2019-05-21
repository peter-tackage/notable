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
      // FIXME This emits too often
      if (state is NotesLoaded) {
        dispatch(LoadChecklist(state.notes.firstWhere(
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
    } else if (event is SaveChecklist) {
      yield* _mapSaveChecklistEventToState(currentState, event);
    } else if (event is DeleteChecklist) {
      yield* _mapDeleteChecklistEventToState(currentState, event);
    } else if (event is SetChecklistItem) {
      yield* _mapAddChecklistItemEventToState(currentState, event);
    } else if (event is AddEmptyChecklistItem) {
      yield* _mapAddEmptyChecklistItemEventToState(currentState, event);
    } else if (event is UpdateChecklistTitle) {
      yield* _mapUpdateChecklistTitleEventToState(currentState, event);
    }
  }

  Stream<ChecklistState> _mapLoadChecklistEventToState(
      ChecklistState currentState, ChecklistEvent event) async* {
    if (event is LoadChecklist) {
      yield ChecklistLoaded(event.checklist);
    }
  }

  Stream<ChecklistState> _mapSaveChecklistEventToState(
      ChecklistState currentState, ChecklistEvent event) async* {
    if (event is SaveChecklist) {
      if (currentState is ChecklistLoaded) {
        print(
            "About to save checklist with title: ${currentState.checklist} with ${currentState.checklist.items.length} items");
        if (id == null) {
          notesBloc.dispatch(AddNote(currentState.checklist));
        } else {
          notesBloc.dispatch(UpdateNote(currentState.checklist));
        }
      }
    }
  }

  Stream<ChecklistState> _mapDeleteChecklistEventToState(
      ChecklistState currentState, ChecklistEvent event) async* {
    if (event is DeleteChecklist) {
      // Delete the note and return all the notes
      notesBloc.dispatch(DeleteNote(id));
    }
  }

  Stream<ChecklistState> _mapAddChecklistItemEventToState(
      ChecklistState currentState, ChecklistEvent event) async* {
    if (event is SetChecklistItem) {
      // Add the item to existing note
      if (currentState is ChecklistLoaded) {
        print("Adding item: ${event.item.task} to position: ${event.index}");
        List<ChecklistItem> items = currentState.checklist.items;
        items[event.index] = event.item;
        yield ChecklistLoaded(currentState.checklist.copyWith(items: items));
      }
    }
  }

  Stream<ChecklistState> _mapAddEmptyChecklistItemEventToState(
      ChecklistState currentState, ChecklistEvent event) async* {
    print("_mapAddEmptyChecklistItemEventToState: $currentState, $event");

    if (event is AddEmptyChecklistItem) {
      // Add the item to existing note
      if (currentState is ChecklistLoaded) {
        print("Adding empty item at the end");
        List<ChecklistItem> items = currentState.checklist.items;
        items.add(ChecklistItem('', false));
        yield ChecklistLoaded(currentState.checklist.copyWith(items: items));
      }
    }
  }

  Stream<ChecklistState> _mapUpdateChecklistTitleEventToState(
      ChecklistState currentState, UpdateChecklistTitle event) async* {
    if (event is UpdateChecklistTitle) {
      if (currentState is ChecklistLoaded) {
        yield ChecklistLoaded(
            currentState.checklist.copyWith(title: event.title));
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    checklistsSubscription.cancel();
  }
}
