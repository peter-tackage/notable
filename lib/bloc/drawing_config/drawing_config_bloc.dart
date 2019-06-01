import 'dart:async';

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
    }
  }

  Stream<DrawingConfigState> _mapSelectDrawingToolEventToState(
      SelectDrawingTool event, DrawingConfigState currentState) async* {
    if (currentState is DrawingConfigLoaded) {
      yield DrawingConfigLoaded(
          currentState.drawingConfig.copyWith(tool: event.tool));
    }
  }
}
