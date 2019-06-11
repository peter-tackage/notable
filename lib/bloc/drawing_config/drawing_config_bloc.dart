import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:notable/model/drawing_config.dart';

import 'drawing_config_events.dart';
import 'drawing_config_states.dart';

class DrawingConfigBloc extends Bloc<DrawingConfigEvent, DrawingConfigState> {
  DrawingConfigBloc();

  @override
  DrawingConfigState get initialState =>
      DrawingConfigLoaded(DrawingConfig.defaults());

  @override
  Stream<DrawingConfigState> mapEventToState(DrawingConfigEvent event) async* {
    if (event is SelectDrawingTool) {
      yield* _mapSelectDrawingToolEventToState(event, currentState);
    } else if (event is SelectDrawingToolColor) {
      yield* _mapSelectDrawingToolColorEventToState(event, currentState);
    } else if (event is SelectToolStyle) {
      yield* _mapSelectDrawingToolStyleEventToState(event, currentState);
    }
  }

  Stream<DrawingConfigState> _mapSelectDrawingToolEventToState(
      SelectDrawingTool event, DrawingConfigState currentState) async* {
    if (currentState is DrawingConfigLoaded) {
      yield DrawingConfigLoaded(
          currentState.drawingConfig.copyWith(tool: event.tool));
    }
  }

  Stream<DrawingConfigState> _mapSelectDrawingToolColorEventToState(
      SelectDrawingToolColor event, DrawingConfigState currentState) async* {
    if (currentState is DrawingConfigLoaded) {
      yield DrawingConfigLoaded(
          currentState.drawingConfig.copyWith(color: Color(event.color)));
    }
  }

  Stream<DrawingConfigState> _mapSelectDrawingToolStyleEventToState(
      SelectToolStyle event, DrawingConfigState currentState) async* {
    if (currentState is DrawingConfigLoaded) {
      yield DrawingConfigLoaded(currentState.drawingConfig
          .copyWith(penShape: event.penShape, strokeWidth: event.strokeWidth));
    }
  }
}
