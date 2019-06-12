import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/base_note.dart';
import 'package:notable/model/drawing_config.dart';

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

abstract class StrokeDrawingAction extends DrawingAction {
  final List<Offset> points;

  StrokeDrawingAction(this.points);

  StrokeDrawingAction copyWith(List<Offset> points);
}

@immutable
class BrushAction extends StrokeDrawingAction {
  final Color color;
  final PenShape penShape;
  final double strokeWidth;

  BrushAction(points, this.color, this.penShape, this.strokeWidth)
      : super(points);

  @override
  void draw(Canvas canvas) {
    Paint paint = Paint()
      ..strokeWidth = this.strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = toStrokeCap(this.penShape)
      ..strokeJoin = toStrokeJoin(this.penShape)
      ..color = color
      ..isAntiAlias = true;

    _drawPoints(canvas, paint, points);
  }

  @override
  String toString() => "BrushAction: ${points.length}";

  @override
  BrushAction copyWith(List<Offset> points) =>
      BrushAction(points, this.color, this.penShape, this.strokeWidth);
}

@immutable
class EraserAction extends StrokeDrawingAction {
  final PenShape penShape;
  final double strokeWidth;

  EraserAction(points, this.penShape, this.strokeWidth) : super(points);

  @override
  void draw(Canvas canvas) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = this.strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = toStrokeCap(this.penShape)
      ..strokeJoin = toStrokeJoin(this.penShape)
      ..isAntiAlias = true
      ..blendMode = BlendMode.clear;

    _drawPoints(canvas, paint, points);
  }

  @override
  String toString() => "EraserAction: ${points.length}";

  @override
  EraserAction copyWith(List<Offset> points) =>
      EraserAction(points, this.penShape, this.strokeWidth);
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

StrokeJoin toStrokeJoin(PenShape penShape) {
  switch (penShape) {
    case PenShape.Square:
      return StrokeJoin.miter;
    case PenShape.Round:
      return StrokeJoin.round;
    default:
      throw Exception("Unsupported PenShape: $penShape");
  }
}

StrokeCap toStrokeCap(PenShape penShape) {
  switch (penShape) {
    case PenShape.Square:
      return StrokeCap.square;
    case PenShape.Round:
      return StrokeCap.round;
    default:
      throw Exception("Unsupported PenShape: $penShape");
  }
}
