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

  DrawingBloc({@required this.notesBloc, @required this.id}) {
    drawingsSubscription = notesBloc.state.listen((state) {
      if (state is NotesLoaded) {
        dispatch(
            LoadDrawing(state.notes.firstWhere((note) => note.id == this.id,
                orElse: () => Drawing((b) => b
                  ..title = ''
                  ..labels = ListBuilder<Label>()
                  ..actions = ListBuilder<DrawingAction>()
                  ..currentIndex = -1)) as Drawing));
      }
    });
  }

  @override
  DrawingState get initialState => DrawingLoading();

  @override
  Stream<DrawingState> mapEventToState(DrawingEvent event) async* {
    if (event is LoadDrawing) {
      yield* _mapLoadDrawingEventToState(currentState, event);
    } else if (event is SaveDrawing) {
      yield* _mapSaveDrawingEventToState(currentState, event);
    } else if (event is DeleteDrawing) {
      yield* _mapDeleteDrawingEventToState(currentState, event);
    } else if (event is ClearDrawing) {
      yield* _mapClearDrawingEventToState(currentState, event);
    } else if (event is Undo) {
      yield* _mapUndoDrawingActionEventToState(currentState, event);
    } else if (event is Redo) {
      yield* _mapRedoDrawingActionEventToState(currentState, event);
    } else if (event is StartDrawing) {
      yield* _mapStartDrawingActionEventToState(currentState, event);
    } else if (event is UpdateDrawing) {
      yield* _mapUpdateDrawingActionEventToState(currentState, event);
    } else if (event is EndDrawing) {
      yield* _mapEndDrawingActionEventToState(currentState, event);
    } else if (event is UpdateDrawingTitle) {
      yield* _mapUpdateDrawingTitleEventToState(currentState, event);
    }
  }

  @override
  void dispose() {
    super.dispose();

    drawingsSubscription.cancel();
  }

  Stream<DrawingState> _mapLoadDrawingEventToState(
      DrawingState currentState, LoadDrawing event) async* {
    yield DrawingLoaded(drawing: event.drawing);
  }

  Stream<DrawingState> _mapSaveDrawingEventToState(
      DrawingState currentState, DrawingEvent event) async* {
    if (currentState is DrawingLoaded) {
      if (id == null) {
        notesBloc.dispatch(AddNote(currentState.drawing));
      } else {
        notesBloc.dispatch(UpdateNote(currentState.drawing));
      }
    }
  }

  Stream<DrawingState> _mapDeleteDrawingEventToState(
      DrawingState currentState, DrawingEvent event) async* {
    assert(id != null);

    // Delete the note and return all the notes
    notesBloc.dispatch(DeleteNote(id));
  }

  Stream<DrawingState> _mapClearDrawingEventToState(
      DrawingState currentState, ClearDrawing event) async* {
    if (currentState is DrawingLoaded) {
      // Move the index so that it's still undo-able.
      yield DrawingLoaded(
          drawing: currentState.drawing.rebuild((b) => b
            ..actions = ListBuilder()
            ..currentIndex = -1));
    }
  }

  Stream<DrawingState> _mapUndoDrawingActionEventToState(
      DrawingState currentState, Undo event) async* {
    if (currentState is DrawingLoaded) {
      int movedIndex = currentState.drawing.currentIndex - 1;
      yield DrawingLoaded(
          drawing: currentState.drawing
              .rebuild((b) => b..currentIndex = movedIndex));
    }
  }

  Stream<DrawingState> _mapRedoDrawingActionEventToState(
      DrawingState currentState, Redo event) async* {
    if (currentState is DrawingLoaded) {
      int movedIndex = currentState.drawing.currentIndex + 1;

      yield DrawingLoaded(
          drawing: currentState.drawing
              .rebuild((b) => b..currentIndex = movedIndex));
    }
  }

  Stream<DrawingState> _mapStartDrawingActionEventToState(
      DrawingState currentState, StartDrawing event) async* {
    if (currentState is DrawingLoaded) {
      // Insert and potentially discard Actions
      int currentIndex = currentState.drawing.currentIndex;

      List<DrawingAction> actions;
      if (currentIndex >= 0 &&
          currentIndex != currentState.drawing.actions.length - 1) {
        actions =
            currentState.drawing.actions.sublist(0, currentIndex + 1).toList();
      } else if (currentIndex == -1) {
        actions = List<DrawingAction>();
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

      yield DrawingLoaded(
          drawing: currentState.drawing.rebuild((b) => b
            ..actions = ListBuilder(actions)
            ..currentIndex = currentIndex));
    }
  }

  Stream<DrawingState> _mapUpdateDrawingActionEventToState(
      DrawingState currentState, UpdateDrawing event) async* {
    if (currentState is DrawingLoaded) {
      DrawingAction currentAction =
          currentState.drawing.actions[currentState.drawing.currentIndex];
      if (currentAction is BrushAction || currentAction is EraserAction) {
        Drawing updatedDrawing = _updateDrawingWithStrokeDrawingActionEvent(
            currentAction, event, currentState);
        yield DrawingLoaded(drawing: updatedDrawing);
      } else {
        throw Exception("Unsupported action type: $currentAction");
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
    StrokeDrawingAction updatedAction =
        currentAction.rebuild((b) => b..points.add(event.offset));

    // Update the action in the overall state
    BuiltList<DrawingAction> updatedActions = currentState.drawing.actions
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
      Drawing updatedDrawing =
          currentState.drawing.rebuild((b) => b..title = event.title);
      yield DrawingLoaded(drawing: updatedDrawing);
    }
  }
}
