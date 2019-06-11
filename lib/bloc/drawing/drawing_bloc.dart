import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
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
        dispatch(LoadDrawing(state.notes.firstWhere(
                (note) => note.id == this.id,
                orElse: () =>
                    Drawing('', List<Label>(), List<DrawingAction>(), -1))
            as Drawing));
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
          drawing:
              currentState.drawing.copyWith(actions: List(), currentIndex: -1));
    }
  }

  Stream<DrawingState> _mapUndoDrawingActionEventToState(
      DrawingState currentState, Undo event) async* {
    if (currentState is DrawingLoaded) {
      int movedIndex = currentState.drawing.currentIndex - 1;
      yield DrawingLoaded(
          drawing: currentState.drawing.copyWith(currentIndex: movedIndex));
    }
  }

  Stream<DrawingState> _mapRedoDrawingActionEventToState(
      DrawingState currentState, Redo event) async* {
    if (currentState is DrawingLoaded) {
      int movedIndex = currentState.drawing.currentIndex + 1;

      yield DrawingLoaded(
          drawing: currentState.drawing.copyWith(currentIndex: movedIndex));
    }
  }

  Stream<DrawingState> _mapStartDrawingActionEventToState(
      DrawingState currentState, StartDrawing event) async* {
    if (currentState is DrawingLoaded) {
      // Insert and potentially discard Actions
      int currentIndex = currentState.drawing.currentIndex;

      List<DrawingAction> actions;
      if (currentIndex >= 0 &&
          currentIndex != currentState.drawing.allActions.length - 1) {
        actions = currentState.drawing.allActions.sublist(0, currentIndex + 1);
      } else if (currentIndex == -1) {
        actions = List<DrawingAction>();
      } else {
        actions = List.of(currentState.drawing.allActions);
      }

      DrawingAction action;
      if (event.config.tool == Tool.Brush) {
        action = BrushAction(<Offset>[event.offset], event.config.color,
            event.config.penShape, event.config.strokeWidth);
      } else if (event.config.tool == Tool.Eraser) {
        action = EraserAction(<Offset>[event.offset], event.config.penShape,
            event.config.strokeWidth);
      }

      actions.add(action);
      currentIndex = actions.length - 1;

      yield DrawingLoaded(
          drawing: currentState.drawing
              .copyWith(actions: actions, currentIndex: currentIndex));
    }
  }

  Stream<DrawingState> _mapUpdateDrawingActionEventToState(
      DrawingState currentState, UpdateDrawing event) async* {
    if (currentState is DrawingLoaded) {
      DrawingAction currentAction =
          currentState.drawing.allActions[currentState.drawing.currentIndex];

      if (currentAction is BrushAction) {
        // This updates the current action with the point associated with the
        // interaction event.
        List<Offset> points = List.of(currentAction.points);
        points.add(event.offset);
        BrushAction updatedAction = currentAction.copyWith(points);

        List<DrawingAction> updatedActions =
            List.of(currentState.drawing.allActions);
        updatedActions[currentState.drawing.currentIndex] = updatedAction;

        Drawing updatedDrawing =
            currentState.drawing.copyWith(actions: updatedActions);

        yield DrawingLoaded(drawing: updatedDrawing);
      } else if (currentAction is EraserAction) {
        // This updates the current action with the point associated with the
        // interaction event.
        List<Offset> points = List.of(currentAction.points);
        points.add(event.offset);
        EraserAction updatedAction = currentAction.copyWith(points);

        List<DrawingAction> updatedActions =
            List.of(currentState.drawing.allActions);
        updatedActions[currentState.drawing.currentIndex] = updatedAction;

        Drawing updatedDrawing =
            currentState.drawing.copyWith(actions: updatedActions);
        yield DrawingLoaded(drawing: updatedDrawing);
      } else {
        throw Exception("Unsupported action type: $currentAction");
      }
    }
  }

  Stream<DrawingState> _mapEndDrawingActionEventToState(
      DrawingState currentState, EndDrawing event) async* {
    // Nothing yet
  }
}
