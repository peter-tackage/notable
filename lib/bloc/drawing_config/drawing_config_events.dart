import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/drawing.dart';
import 'package:notable/model/drawing_config.dart';

@immutable
abstract class DrawingConfigEvent extends Equatable {
  DrawingConfigEvent([List props = const []]) : super(props);
}

@immutable
class LoadDrawingConfig extends DrawingConfigEvent {
  LoadDrawingConfig() : super([]);

  @override
  String toString() => 'LoadDrawingConfig';
}

@immutable
class SelectDrawingTool extends DrawingConfigEvent {
  final Tool tool;

  SelectDrawingTool(this.tool) : super([tool]);

  @override
  String toString() => 'SelectDrawingTool';
}

@immutable
class SelectDrawingToolColor extends DrawingConfigEvent {
  final int color;

  SelectDrawingToolColor(this.color) : super([color]);

  @override
  String toString() => 'SelectDrawingToolColor';
}

@immutable
class SelectToolStyle extends DrawingConfigEvent {
  final PenShape penShape;
  final double strokeWidth;

  SelectToolStyle(this.penShape, this.strokeWidth)
      : super([penShape, strokeWidth]);

  @override
  String toString() => 'SelectToolStyle';
}
