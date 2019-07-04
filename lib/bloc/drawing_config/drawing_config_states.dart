import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/drawing_config.dart';

@immutable
abstract class DrawingConfigState extends Equatable {
  DrawingConfigState([List props = const []]) : super(props);
}

@immutable
class DrawingConfigLoaded extends DrawingConfigState {
  final DrawingConfig drawingConfig;

  DrawingConfigLoaded(this.drawingConfig) : super([drawingConfig]);

  @override
  String toString() => 'DrawingConfigLoaded: { drawingConfig: $drawingConfig }';
}
