import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:notable/model/drawing_config.dart';

import 'drawing_config_events.dart';
import 'drawing_config_states.dart';

class DrawingConfigBloc extends Bloc<DrawingConfigEvent, DrawingConfigState> {
  DrawingConfigBloc();

  @override
  DrawingConfigState get initialState => DrawingConfigLoaded(DrawingConfig());

  @override
  Stream<DrawingConfigState> mapEventToState(DrawingConfigEvent event) async* {
    print("Drawing Bloc got event: $event");
  }
}
