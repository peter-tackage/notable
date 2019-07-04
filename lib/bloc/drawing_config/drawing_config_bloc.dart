import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:notable/model/drawing_config.dart';

import 'drawing_config_events.dart';
import 'drawing_config_states.dart';

class DrawingConfigBloc extends Bloc<DrawingConfigEvent, DrawingConfigState> {
  static final int fullyOpaqueAlpha = 255;

  DrawingConfigBloc();

  @override
  DrawingConfigState get initialState =>
      DrawingConfigLoaded(DrawingConfig((b) => b
        ..tool = Tool.Brush
        ..penShape = PenShape.Square
        ..strokeWidth = 5
        ..color = Colors.blue.value
        ..alpha = fullyOpaqueAlpha));

  @override
  Stream<DrawingConfigState> mapEventToState(DrawingConfigEvent event) async* {
    if (event is SelectDrawingTool) {
      yield* _mapSelectDrawingToolEventToState(event, currentState);
    } else if (event is SelectDrawingToolColor) {
      yield* _mapSelectDrawingToolColorEventToState(event, currentState);
    } else if (event is SelectDrawingToolAlpha) {
      yield* _mapSelectDrawingToolAlphaEventToState(event, currentState);
    } else if (event is SelectToolStyle) {
      yield* _mapSelectDrawingToolStyleEventToState(event, currentState);
    }
  }

  Stream<DrawingConfigState> _mapSelectDrawingToolEventToState(
      SelectDrawingTool event, DrawingConfigState currentState) async* {
    if (currentState is DrawingConfigLoaded) {
      yield DrawingConfigLoaded(
          currentState.drawingConfig.rebuild((b) => b..tool = event.tool));
    }
  }

  Stream<DrawingConfigState> _mapSelectDrawingToolColorEventToState(
      SelectDrawingToolColor event, DrawingConfigState currentState) async* {
    if (currentState is DrawingConfigLoaded) {
      yield DrawingConfigLoaded(
          currentState.drawingConfig.rebuild((b) => b..color = event.color));
    }
  }

  Stream<DrawingConfigState> _mapSelectDrawingToolAlphaEventToState(
      SelectDrawingToolAlpha event, DrawingConfigState currentState) async* {
    if (currentState is DrawingConfigLoaded) {
      // If we
      yield DrawingConfigLoaded(
          currentState.drawingConfig.rebuild((b) => b..alpha = event.alpha));
    }
  }

  Stream<DrawingConfigState> _mapSelectDrawingToolStyleEventToState(
      SelectToolStyle event, DrawingConfigState currentState) async* {
    if (currentState is DrawingConfigLoaded) {
      yield DrawingConfigLoaded(currentState.drawingConfig.rebuild((b) => b
        ..penShape = event.penShape
        ..strokeWidth = event.strokeWidth));
    }
  }
}
