import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

enum Tool { Brush, Eraser }

@immutable
class DrawingConfig {
  final Tool tool;
  final Color color;

  DrawingConfig({@required this.tool, @required this.color});

  DrawingConfig.defaults({this.tool = Tool.Brush, this.color = Colors.blue});

  DrawingConfig copyWith({Tool tool, Color color}) {
    return DrawingConfig(tool: tool ?? this.tool, color: color ?? this.color);
  }
}
