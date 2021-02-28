import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/bloc/notes/notes_states.dart';
import 'package:notable/entity/drawing_entity.dart';
import 'package:notable/model/drawing.dart';
import 'package:notable/model/drawing_config.dart';
import 'package:notable/model/label.dart';

import 'drawing_events.dart';
import 'drawing_states.dart';

class DrawingBloc extends Bloc<DrawingEvent, DrawingState> {
  final NotesBloc<Drawing, DrawingEntity> notesBloc;
  final String id;

  StreamSubscription drawingsSubscription;

  DrawingBloc({@required this.notesBloc, @required this.id})
      : super(_initialState(notesBloc, id)) {
    drawingsSubscription = notesBloc.listen((state) {
      if (state is NotesLoaded) {
        add(LoadDrawing(state.notes.findForId(id)));
      }
    });
  }

  static DrawingState _initialState(
      NotesBloc<Drawing, DrawingEntity> notesBloc, String id) {
    if (id == null) {
      return DrawingLoaded(Drawing((b) => b
        ..title = ''
        ..labels = ListBuilder<Label>()
        ..actions = ListBuilder<DrawingAction>()
        ..currentIndex = -1));
    } else if (notesBloc.state is NotesLoaded) {
      return DrawingLoaded(
          (notesBloc.state as NotesLoaded).notes.findForId(id));
    } else {
      return DrawingLoading();
    }
  }

  @override
  Stream<DrawingState> mapEventToState(DrawingEvent event) async* {
    if (event is LoadDrawing) {
      yield* _mapLoadDrawingEventToState(state, event);
    } else if (event is SaveDrawing) {
      yield* _mapSaveDrawingEventToState(state, event);
    } else if (event is DeleteDrawing) {
      yield* _mapDeleteDrawingEventToState(state, event);
    } else if (event is ClearDrawing) {
      yield* _mapClearDrawingEventToState(state, event);
    } else if (event is Undo) {
      yield* _mapUndoDrawingActionEventToState(state, event);
    } else if (event is Redo) {
      yield* _mapRedoDrawingActionEventToState(state, event);
    } else if (event is StartDrawing) {
      yield* _mapStartDrawingActionEventToState(state, event);
    } else if (event is UpdateDrawing) {
      yield* _mapUpdateDrawingActionEventToState(state, event);
    } else if (event is EndDrawing) {
      yield* _mapEndDrawingActionEventToState(state, event);
    } else if (event is UpdateDrawingTitle) {
      yield* _mapUpdateDrawingTitleEventToState(state, event);
    }
  }

  @override
  Future<Function> close() {
    drawingsSubscription.cancel();
    return super.close();
  }

  Stream<DrawingState> _mapLoadDrawingEventToState(
      DrawingState currentState, LoadDrawing event) async* {
    yield DrawingLoaded(event.drawing);
  }

  Stream<DrawingState> _mapSaveDrawingEventToState(
      DrawingState currentState, DrawingEvent event) async* {
    if (currentState is DrawingLoaded) {
      if (id == null) {
        notesBloc.add(AddNote(currentState.drawing));
      } else {
        notesBloc.add(UpdateNote(currentState.drawing));
      }
    }
  }

  Stream<DrawingState> _mapDeleteDrawingEventToState(
      DrawingState currentState, DrawingEvent event) async* {
    assert(id != null);

    // Delete the note and return all the notes
    notesBloc.add(DeleteNote(id));
  }

  Stream<DrawingState> _mapClearDrawingEventToState(
      DrawingState currentState, ClearDrawing event) async* {
    if (currentState is DrawingLoaded) {
      // Move the index so that it's still undo-able.
      yield DrawingLoaded(currentState.drawing.rebuild((b) => b
        ..actions = ListBuilder()
        ..currentIndex = -1));
    }
  }

  Stream<DrawingState> _mapUndoDrawingActionEventToState(
      DrawingState currentState, Undo event) async* {
    if (currentState is DrawingLoaded) {
      var movedIndex = currentState.drawing.currentIndex - 1;
      yield DrawingLoaded(
          currentState.drawing.rebuild((b) => b..currentIndex = movedIndex));
    }
  }

  Stream<DrawingState> _mapRedoDrawingActionEventToState(
      DrawingState currentState, Redo event) async* {
    if (currentState is DrawingLoaded) {
      var movedIndex = currentState.drawing.currentIndex + 1;

      yield DrawingLoaded(
          currentState.drawing.rebuild((b) => b..currentIndex = movedIndex));
    }
  }

  Stream<DrawingState> _mapStartDrawingActionEventToState(
      DrawingState currentState, StartDrawing event) async* {
    if (currentState is DrawingLoaded) {
      // Insert and potentially discard Actions
      var currentIndex = currentState.drawing.currentIndex;

      List<DrawingAction> actions;
      if (currentIndex >= 0 &&
          currentIndex != currentState.drawing.actions.length - 1) {
        actions =
            currentState.drawing.actions.sublist(0, currentIndex + 1).toList();
      } else if (currentIndex == -1) {
        actions = <DrawingAction>[];
      } else {
        actions = List.of(currentState.drawing.actions);
      }

      DrawingAction action;
      if (event.config.tool == Tool.Brush) {
        action = BrushAction((b) => b
          ..points = ListBuilder<OffsetValue>([event.offset])
          ..color = event.config.color
          ..alpha = event.config.alpha
          ..penShape = event.config.penShape
          ..strokeWidth = event.config.strokeWidth);
      } else if (event.config.tool == Tool.Eraser) {
        action = EraserAction((b) => b
          ..points = ListBuilder<OffsetValue>([event.offset])
          ..penShape = event.config.penShape
          ..strokeWidth = event.config.strokeWidth);
      }

      actions = [...actions, action]; // ignore: sdk_version_ui_as_code
      currentIndex = actions.length - 1;

      yield DrawingLoaded(currentState.drawing.rebuild((b) => b
        ..actions = ListBuilder(actions)
        ..currentIndex = currentIndex));
    }
  }

  Stream<DrawingState> _mapUpdateDrawingActionEventToState(
      DrawingState currentState, UpdateDrawing event) async* {
    if (currentState is DrawingLoaded) {
      var currentAction =
          currentState.drawing.actions[currentState.drawing.currentIndex];
      if (currentAction is BrushAction || currentAction is EraserAction) {
        var updatedDrawing = _updateDrawingWithStrokeDrawingActionEvent(
            currentAction, event, currentState);
        yield DrawingLoaded(updatedDrawing);
      } else {
        throw Exception('Unsupported action type: $currentAction');
      }
    }
  }

  // FIXME Can probably compact this a bit, we extract bits and put them back in when it could be possible to do it one statement.

  // This adds another point to an ongoing action in the current state
  Drawing _updateDrawingWithStrokeDrawingActionEvent(
      StrokeDrawingAction currentAction,
      UpdateDrawing event,
      DrawingLoaded currentState) {
    // Add the new event to the current action
    var updatedAction =
        currentAction.rebuild((b) => b..points.add(event.offset));

    // Update the action in the overall state
    var updatedActions = currentState.drawing.actions
        .rebuild((b) => b..[currentState.drawing.currentIndex] = updatedAction);

    // Update the drawing with the new items
    return currentState.drawing
        .rebuild((existing) => existing..actions.replace(updatedActions));
  }

  Stream<DrawingState> _mapEndDrawingActionEventToState(
      DrawingState currentState, EndDrawing event) async* {
    // Nothing yet
  }

  Stream<DrawingState> _mapUpdateDrawingTitleEventToState(
      DrawingState currentState, UpdateDrawingTitle event) async* {
    if (currentState is DrawingLoaded) {
      var updatedDrawing =
          currentState.drawing.rebuild((b) => b..title = event.title);
      yield DrawingLoaded(updatedDrawing);
    }
  }
}
