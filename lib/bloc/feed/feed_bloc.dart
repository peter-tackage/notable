import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:notable/bloc/feed/feed_events.dart';
import 'package:notable/bloc/feed/feed_states.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/bloc/notes/notes_states.dart';
import 'package:notable/entity/audio_note_entity.dart';
import 'package:notable/entity/drawing_entity.dart';
import 'package:notable/entity/entity.dart';
import 'package:notable/model/audio_note.dart';
import 'package:notable/model/checklist.dart';
import 'package:notable/model/drawing.dart';
import 'package:notable/model/text_note.dart';
import 'package:stream_transform/stream_transform.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final NotesBloc<TextNote, TextNoteEntity> textNotesBloc;
  final NotesBloc<Checklist, ChecklistEntity> checklistNotesBloc;
  final NotesBloc<Drawing, DrawingEntity> drawingNotesBloc;
  final NotesBloc<AudioNote, AudioNoteEntity> audioNotesBloc;

  StreamSubscription combinedNotesSubscription;

  FeedBloc(
      {@required this.textNotesBloc,
      @required this.checklistNotesBloc,
      @required this.drawingNotesBloc,
      @required this.audioNotesBloc})
      : super(FeedLoading()) {
    // Await all the notes, combined into a single event.
    combinedNotesSubscription = subscribeAllNotes();
  }

  StreamSubscription<List<NotesState>> subscribeAllNotes() {
    return textNotesBloc.combineLatestAll([
      checklistNotesBloc,
      drawingNotesBloc,
      audioNotesBloc
    ]).listen((noteStates) => add(NoteStatesChanged(noteStates)));
  }

  @override
  Stream<FeedState> mapEventToState(FeedEvent event) async* {
    if (event is LoadFeed) {
      _mapEventLoadFeedToActions();
    } else if (event is NoteStatesChanged) {
      yield* _mapNotesStateChangedToState(event.noteStates);
    }
  }

  void _mapEventLoadFeedToActions() {
    textNotesBloc.add(LoadNotes());
    checklistNotesBloc.add(LoadNotes());
    drawingNotesBloc.add(LoadNotes());
    audioNotesBloc.add(LoadNotes());
  }

  @override
  Future<void> close() {
    combinedNotesSubscription.cancel();
    return super.close();
  }

  Stream<FeedState> _mapNotesStateChangedToState(
      List<NotesState> allNoteState) async* {
    // Require all notes to be loaded to display them, otherwise loading.
    if (allNoteState.every((noteState) => noteState is NotesLoaded)) {
      // Combine all the notes into a single list.
      final List allNotes = allNoteState
          .map((notes) => notes as NotesLoaded)
          .expand((loadNotes) => loadNotes.notes)
          .toList();

      // Sort so most recent are at top
      allNotes.sort((a, b) => b.updatedDate.compareTo(a.updatedDate));

      yield FeedLoaded(allNotes);
    } else {
      // If any are loading, then the whole feed is loading.
      yield FeedLoading();
    }
  }
}
