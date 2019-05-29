import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

enum Tool { Brush, Eraser }

@immutable
class DrawingConfig {
  final Tool tool;
  final Color color;

  DrawingConfig({this.tool = Tool.Brush, this.color = Colors.blue});
}
