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

  //
  // FIXME This implementation is a bit bad.
  // - Too much effort to update (remove + add)
  // - Don't want to keep them separate, when merge because then Widget needs to
  // do too much work.
  // - Perhaps keep it as a map, and merge on accessing?
  //

  Stream<FeedState> _mapTextNotesLoadedEventToState(FeedState currentState,
      FeedEvent event) async* {
    if (event is TextNotesLoaded) {
      List<BaseNote> notes;

      if (currentState is FeedLoaded) {
        notes = List.from(currentState.feed);
        notes.removeWhere((note) => note is TextNote);
        notes.addAll(event.textNotes);
      } else {
        notes = event.textNotes;
      }

      notes.sort((a, b) => b.updatedDate.compareTo(a.updatedDate));

      yield (FeedLoaded(notes));
    }
  }

  Stream<FeedState> _mapChecklistsLoadedEventToState(FeedState currentState,
      FeedEvent event) async* {
    if (event is ChecklistsLoaded) {
      List<BaseNote> notes;

      if (currentState is FeedLoaded) {
        notes = List.from(currentState.feed);
        notes.removeWhere((note) => note is Checklist);
        notes.addAll(event.checklists);
      } else {
        notes = event.checklists;
      }

      notes.sort((a, b) => b.updatedDate.compareTo(a.updatedDate));

      yield (FeedLoaded(notes));
    }
  }

  @override
  void dispose() {
    super.dispose();
    textNotesSubscription.cancel();
    checklistsSubscription.cancel();
  }
}
