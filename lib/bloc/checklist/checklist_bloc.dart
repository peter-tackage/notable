import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';
import 'package:notable/bloc/checklist/checklist_events.dart';
import 'package:notable/bloc/checklist/checklist_states.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/bloc/notes/notes_states.dart';
import 'package:notable/entity/entity.dart';
import 'package:notable/model/checklist.dart';
import 'package:notable/model/label.dart';

class ChecklistBloc extends Bloc<ChecklistEvent, ChecklistState> {
  final NotesBloc<Checklist, ChecklistEntity> notesBloc;
  final String id;

  StreamSubscription checklistsSubscription;

  ChecklistBloc({@required this.notesBloc, @required this.id}) {
    checklistsSubscription = notesBloc.state.listen((state) {
      if (state is NotesLoaded) {
        // FIXME Editing entries with no items renders as empty
        // FIXME This dispatches too often
        dispatch(LoadChecklist(
            state.notes.firstWhere((note) => note.id == this.id,
                    orElse: () => Checklist((b) => b
                      ..title = ''
                      ..labels = ListBuilder<Label>()
                      ..items = ListBuilder([ChecklistItem.empty()])))
                as Checklist));
      }
    });
  }

  @override
  ChecklistState get initialState => ChecklistLoading();

  @override
  Stream<ChecklistState> mapEventToState(ChecklistEvent event) async* {
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
    } else if (event is RemoveChecklistItem) {
      yield* _mapRemoveChecklistItemEventToState(currentState, event);
    }
  }

  Stream<ChecklistState> _mapLoadChecklistEventToState(
      ChecklistState currentState, ChecklistEvent event) async* {
    if (event is LoadChecklist) {
      // We apply the item sorting here so that the insertion order of the items
      // is not altered by toggling the done flag.
      List<ChecklistItem> items = List.from(event.checklist.items);
      items.sort(itemComparator);

      yield ChecklistLoaded(
          event.checklist.rebuild((b) => b..items.replace(items)));
    }
  }

  int itemComparator(ChecklistItem a, ChecklistItem b) {
    if (a.isDone && !b.isDone) return 1;
    if (!a.isDone && b.isDone) return -1;

    return 0;
  }

  Stream<ChecklistState> _mapSaveChecklistEventToState(
      ChecklistState currentState, ChecklistEvent event) async* {
    if (event is SaveChecklist) {
      if (currentState is ChecklistLoaded) {
        Checklist checklist = currentState.checklist
            .rebuild((b) => b..items.removeWhere((item) => item.isEmpty));

        if (id == null) {
          notesBloc.dispatch(AddNote(checklist));
        } else {
          notesBloc.dispatch(UpdateNote(checklist));
        }
      }
    }
  }

  Stream<ChecklistState> _mapDeleteChecklistEventToState(
      ChecklistState currentState, ChecklistEvent event) async* {
    if (event is DeleteChecklist) {
      // Delete the note and return all the notes
      if (id != null) {
        notesBloc.dispatch(DeleteNote(id));
      }
    }
  }

  Stream<ChecklistState> _mapAddChecklistItemEventToState(
      ChecklistState currentState, ChecklistEvent event) async* {
    if (event is SetChecklistItem) {
      // Add the item to existing note
      if (currentState is ChecklistLoaded) {
        List<ChecklistItem> items = List.from(currentState.checklist.items);
        items[event.index] = event.item;
        items.sort(itemComparator);

        yield ChecklistLoaded(
            currentState.checklist.rebuild((b) => b..items.replace(items)));
      }
    }
  }

  Stream<ChecklistState> _mapRemoveChecklistItemEventToState(
      ChecklistState currentState, ChecklistEvent event) async* {
    if (event is RemoveChecklistItem) {
      // Add the item to existing note
      if (currentState is ChecklistLoaded) {
        List<ChecklistItem> items = List.from(currentState.checklist.items);
        items.removeAt(event.index);
        items.sort(itemComparator);

        yield ChecklistLoaded(
            currentState.checklist.rebuild((b) => b..items.replace(items)));
      }
    }
  }

  Stream<ChecklistState> _mapAddEmptyChecklistItemEventToState(
      ChecklistState currentState, ChecklistEvent event) async* {
    if (event is AddEmptyChecklistItem) {
      // Add the item to existing note
      if (currentState is ChecklistLoaded) {
        List<ChecklistItem> items = List.from(currentState.checklist.items);
        items.add(ChecklistItem.empty());
        yield ChecklistLoaded(
            currentState.checklist.rebuild((b) => b.items.replace(items)));
      }
    }
  }

  Stream<ChecklistState> _mapUpdateChecklistTitleEventToState(
      ChecklistState currentState, UpdateChecklistTitle event) async* {
    if (event is UpdateChecklistTitle) {
      if (currentState is ChecklistLoaded) {
        yield ChecklistLoaded(
            currentState.checklist.rebuild((b) => b..title = event.title));
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    checklistsSubscription.cancel();
  }
}
