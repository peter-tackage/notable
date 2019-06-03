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
import 'package:notable/model/base_note.dart';
import 'package:notable/model/checklist.dart';
import 'package:notable/model/drawing.dart';
import 'package:notable/model/text_note.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final NotesBloc<TextNote, NoteEntity> textNotesBloc;
  final NotesBloc<Checklist, ChecklistEntity> checklistNotesBloc;
  final NotesBloc<Drawing, DrawingEntity> drawingNotesBloc;
  final NotesBloc<AudioNote, AudioNoteEntity> audioNotesBloc;

  StreamSubscription textNotesSubscription;
  StreamSubscription checklistsSubscription;
  StreamSubscription drawingsSubscription;
  StreamSubscription audioNotesSubscription;

  FeedBloc(
      {@required this.textNotesBloc,
      @required this.checklistNotesBloc,
      @required this.drawingNotesBloc,
      @required this.audioNotesBloc}) {
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
    drawingsSubscription = drawingNotesBloc.state.listen((state) {
      if (state is NotesLoaded) {
        dispatch(DrawingsLoaded(state.notes));
      }
    });
    audioNotesSubscription = audioNotesBloc.state.listen((state) {
      if (state is NotesLoaded) {
        dispatch(AudioNotesLoaded(state.notes));
      }
    });
  }

  @override
  FeedState get initialState => FeedLoading();

  @override
  Stream<FeedState> mapEventToState(FeedEvent event) async* {
    if (event is LoadFeed) {
      textNotesBloc.dispatch(LoadNotes());
      checklistNotesBloc.dispatch(LoadNotes());
      drawingNotesBloc.dispatch(LoadNotes());
      audioNotesBloc.dispatch(LoadNotes());
    } else if (event is TextNotesLoaded) {
      yield* _mapTextNotesLoadedEventToState(currentState, event);
    } else if (event is ChecklistsLoaded) {
      yield* _mapChecklistsLoadedEventToState(currentState, event);
    } else if (event is DrawingsLoaded) {
      yield* _mapDrawingsLoadedEventToState(currentState, event);
    } else if (event is AudioNotesLoaded) {
      yield* _mapAudioNotesLoadedEventToState(currentState, event);
    }
  }

  //
  // FIXME This implementation is a bit bad.
  // - Too much effort to update (remove + add)
  // - Don't want to keep them separate, when merge because then Widget needs to
  // do too much work.
  // - Perhaps keep it as a map, and merge on accessing?
  //

  Stream<FeedState> _mapTextNotesLoadedEventToState(
      FeedState currentState, FeedEvent event) async* {
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

  Stream<FeedState> _mapChecklistsLoadedEventToState(
      FeedState currentState, FeedEvent event) async* {
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

  Stream<FeedState> _mapDrawingsLoadedEventToState(
      FeedState currentState, FeedEvent event) async* {
    if (event is DrawingsLoaded) {
      List<BaseNote> notes;

      if (currentState is FeedLoaded) {
        notes = List.from(currentState.feed);
        notes.removeWhere((note) => note is Drawing);
        notes.addAll(event.drawings);
      } else {
        notes = event.drawings;
      }

      notes.sort((a, b) => b.updatedDate.compareTo(a.updatedDate));

      yield (FeedLoaded(notes));
    }
  }

  Stream<FeedState> _mapAudioNotesLoadedEventToState(
      FeedState currentState, FeedEvent event) async* {
    if (event is AudioNotesLoaded) {
      List<BaseNote> notes;

      if (currentState is FeedLoaded) {
        notes = List.from(currentState.feed);
        notes.removeWhere((note) => note is AudioNote);
        notes.addAll(event.audioNotes);
      } else {
        notes = event.audioNotes;
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
    drawingsSubscription.cancel();
    audioNotesSubscription.cancel();
  }
}
