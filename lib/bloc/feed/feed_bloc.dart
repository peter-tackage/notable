import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:notable/bloc/feed/feed_events.dart';
import 'package:notable/bloc/feed/feed_states.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/bloc/notes/notes_states.dart';
import 'package:notable/entity/entity.dart';
import 'package:notable/model/base_note.dart';
import 'package:notable/model/checklist.dart';
import 'package:notable/model/text_note.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final NotesBloc<TextNote, NoteEntity> textNotesBloc;
  final NotesBloc<Checklist, ChecklistEntity> checklistNotesBloc;

  StreamSubscription textNotesSubscription;
  StreamSubscription checklistsSubscription;

  FeedBloc({@required this.textNotesBloc, @required this.checklistNotesBloc}) {
    textNotesSubscription = textNotesBloc.state.listen((state) {
      if (state is NotesLoaded) {
        dispatch(TextNotesLoaded(state.notes));
      }
    });
    checklistsSubscription = checklistNotesBloc.state.listen((state) {
      if (state is NotesLoaded) {
        dispatch(ChecklistsLoaded(state.notes));
      }
    });
  }

  @override
  FeedState get initialState => FeedLoading();

  @override
  Stream<FeedState> mapEventToState(FeedEvent event) async* {
    print("FeedBloc got event: $event");
    if (event is LoadFeed) {
      textNotesBloc.dispatch(LoadNotes());
      checklistNotesBloc.dispatch(LoadNotes());
    } else if (event is TextNotesLoaded) {
      yield* _mapTextNotesLoadedEventToState(currentState, event);
    } else if (event is ChecklistsLoaded) {
      yield* _mapChecklistsLoadedEventToState(currentState, event);
    }
  }

  Stream<FeedState> _mapTextNotesLoadedEventToState(
      FeedState currentState, FeedEvent event) async* {
    if (event is TextNotesLoaded) {
      if (currentState is FeedLoaded) {
        List<BaseNote> updated = List.from(currentState.feed);
        updated.removeWhere((note) => note is TextNote);
        updated.addAll(event.textNotes);
        yield (FeedLoaded(updated));
      } else {
        yield (FeedLoaded(event.textNotes));
      }
    }
  }

  Stream<FeedState> _mapChecklistsLoadedEventToState(
      FeedState currentState, FeedEvent event) async* {
    if (event is ChecklistsLoaded) {
      if (currentState is FeedLoaded) {
        List<BaseNote> updated = List.from(currentState.feed);
        updated.removeWhere((note) => note is Checklist);
        updated.addAll(event.checklists);
        yield (FeedLoaded(updated));
      } else {
        yield (FeedLoaded(event.checklists));
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    textNotesSubscription.cancel();
    checklistsSubscription.cancel();
  }
}
