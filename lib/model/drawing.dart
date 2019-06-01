import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/base_note.dart';

@immutable
class Drawing extends BaseNote {
  final List<DrawingAction> allActions;
  final int currentIndex;

  // FIXME Derived properties - should these instead be calculated on demand?
  final List<DrawingAction> displayedActions; // derived subset
  final bool canUndo;
  final bool canRedo;

  Drawing(title, labels, this.allActions, this.currentIndex, {id, updatedDate})
      : this.displayedActions = _selectDisplayed(allActions, currentIndex),
        this.canUndo = _canUndo(allActions, currentIndex),
        this.canRedo = _canRedo(allActions, currentIndex),
        super(title, labels, id: id, updatedDate: updatedDate);

  Drawing copyWith(
      {String title, List<DrawingAction> actions, int currentIndex}) {
    return Drawing(title ?? this.title, this.labels, actions ?? this.allActions,
        currentIndex ?? this.currentIndex,
        id: id, updatedDate: updatedDate);
  }

  @override
  String toString() {
    return 'Drawing: $title';
  }

  static List<DrawingAction> _selectDisplayed(
          List<DrawingAction> actions, int lastIndex) =>
      actions.sublist(0, lastIndex + 1);

  static _canUndo(List<DrawingAction> allActions, int currentIndex) {
    return currentIndex >= 0;
  }

  static _canRedo(List<DrawingAction> allActions, int currentIndex) {
    return allActions.length > 0 && currentIndex < allActions.length - 1;
  }
}

abstract class DrawingAction {
  void draw(Canvas canvas);
}

@immutable
class BrushAction extends DrawingAction {
  final List<Offset> points;
  final Color color;

  BrushAction(this.points, this.color) : super();

  @override
  void draw(Canvas canvas) {
    Paint paint = Paint()
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = color
      ..isAntiAlias = true;

    _drawPoints(canvas, paint, points);
  }

  @override
  String toString() => "BrushAction: ${points.length}";

  BrushAction copyWith(List<Offset> points) {
    return BrushAction(points, this.color);
  }
}

@immutable
class EraserAction extends DrawingAction {
  final List<Offset> points;

  EraserAction(this.points) : super();

  @override
  void draw(Canvas canvas) {
    Paint paint = Paint()
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true
      ..blendMode = BlendMode.clear;

    _drawPoints(canvas, paint, points);
  }

  @override
  String toString() => "EraserAction: ${points.length}";

  EraserAction copyWith(List<Offset> points) {
    return EraserAction(points);
  }
}

// TODO Move this somewhere, a utils class.
void _drawPoints(Canvas canvas, Paint paint, List<Offset> points) {
  Path path = Path();
  for (int index = 0; index <= points.length - 1; index++) {
    Offset point = points[index];
    if (index == 0) {
      path.moveTo(point.dx, point.dy);
    }
    path.lineTo(point.dx, point.dy);
  }
  canvas.drawPath(path, paint);
}
