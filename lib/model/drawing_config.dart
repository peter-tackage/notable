import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

enum Tool { Brush, Eraser }
enum PenShape { Square, Round }

@immutable
class DrawingConfig {
  final Tool tool;
  final PenShape penShape;
  final double strokeWidth;
  final int color;

  DrawingConfig(
      {@required this.tool,
      @required this.penShape,
      @required this.strokeWidth,
      @required this.color});

  DrawingConfig.defaults()
      : this.tool = Tool.Brush,
        this.penShape = PenShape.Square,
        this.strokeWidth = 5,
        this.color = Colors.blue.value;

  DrawingConfig copyWith(
      {Tool tool, PenShape penShape, double strokeWidth, int color}) {
    return DrawingConfig(
        tool: tool ?? this.tool,
        penShape: penShape ?? this.penShape,
        strokeWidth: strokeWidth ?? this.strokeWidth,
        color: color ?? this.color);
  }
}
