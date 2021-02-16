import 'package:equatable/equatable.dart';
import 'package:notable/model/drawing_config.dart';

abstract class DrawingConfigEvent extends Equatable {
  const DrawingConfigEvent();

  @override
  List<Object> get props => [];
}

class LoadDrawingConfig extends DrawingConfigEvent {}

class SelectDrawingTool extends DrawingConfigEvent {
  final Tool tool;

  const SelectDrawingTool(this.tool);

  @override
  List<Object> get props => [tool];

  @override
  String toString() => 'SelectDrawingTool: { tool : $tool }';
}

class SelectDrawingToolColor extends DrawingConfigEvent {
  final int color;

  const SelectDrawingToolColor(this.color);

  @override
  List<Object> get props => [color];

  @override
  String toString() => 'SelectDrawingToolColor: { color: $color }';
}

class SelectDrawingToolAlpha extends DrawingConfigEvent {
  final int alpha;

  const SelectDrawingToolAlpha(this.alpha);

  @override
  List<Object> get props => [alpha];

  @override
  String toString() => 'SelectDrawingToolAlpha: { alpha : $alpha }';
}

class SelectToolStyle extends DrawingConfigEvent {
  final PenShape penShape;
  final double strokeWidth;

  const SelectToolStyle(this.penShape, this.strokeWidth);

  @override
  List<Object> get props => [penShape, strokeWidth];

  @override
  String toString() =>
      'SelectToolStyle: { penShape: $penShape, strokeWidth: $strokeWidth }';
}
