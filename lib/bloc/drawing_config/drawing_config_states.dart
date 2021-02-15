import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/drawing_config.dart';

@immutable
abstract class DrawingConfigState extends Equatable {
  const DrawingConfigState();
  @override
  List<Object> get props => [];
}

@immutable
class DrawingConfigLoaded extends DrawingConfigState {
  final DrawingConfig drawingConfig;

  const DrawingConfigLoaded(this.drawingConfig);

  @override
  List<Object> get props => [drawingConfig];

  @override
  String toString() => 'DrawingConfigLoaded: { drawingConfig: $drawingConfig }';
}
