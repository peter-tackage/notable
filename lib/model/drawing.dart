import 'dart:ui';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:flutter/material.dart' hide Builder;
import 'package:meta/meta.dart';
import 'package:notable/model/base_note.dart';
import 'package:notable/model/drawing_config.dart';
import 'package:notable/model/label.dart';

part 'drawing.g.dart';

@immutable
abstract class Drawing implements BaseNote, Built<Drawing, DrawingBuilder> {
  BuiltList<DrawingAction> get actions;

  int get currentIndex;

  //
  // Derived properties
  //

  List<DrawingAction> get displayedActions => _selectDisplayed();

  bool get canUndo => _canUndo();

  bool get canRedo => _canRedo();

  @override
  String toString() {
    return 'Drawing: $title';
  }

  Drawing._();

  factory Drawing([updates(DrawingBuilder b)]) = _$Drawing;

  List<DrawingAction> _selectDisplayed() =>
      actions.sublist(0, currentIndex + 1).toList();

  _canUndo() => currentIndex >= 0;

  _canRedo() => actions.isNotEmpty && currentIndex < actions.length - 1;
}

@BuiltValue(instantiable: false)
@immutable
abstract class DrawingAction {
  void draw(Canvas canvas);
}

@BuiltValue(instantiable: false)
@immutable
abstract class StrokeDrawingAction implements DrawingAction {
  BuiltList<OffsetValue>
      get points; // can't use Flutter's Offset and built_value either it would seem.

  @nullable
  int get color; // can't use Flutter's Color and built_value (https://github.com/google/built_value.dart/issues/513)

  @nullable
  int get alpha; // range 0 to 255

  PenShape get penShape;

  double get strokeWidth;

  //
  // We include these operations for non-instantiable base classes with properties.
  //

  StrokeDrawingAction rebuild(
      void Function(StrokeDrawingActionBuilder) updates);

  StrokeDrawingActionBuilder toBuilder();
}

@immutable
abstract class BrushAction
    implements StrokeDrawingAction, Built<BrushAction, BrushActionBuilder> {
  @override
  void draw(Canvas canvas) {
    Paint paint = Paint()
      ..strokeWidth = this.strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = toStrokeCap(this.penShape)
      ..strokeJoin = toStrokeJoin(this.penShape)
      ..color = Color(this.color).withAlpha(this.alpha)
      ..isAntiAlias = true;

    _drawPoints(canvas, paint,
        points.map((offset) => Offset(offset.dx, offset.dy)).toList());
  }

  @override
  String toString() => "BrushAction: ${points.length}";

  //
  // We include these operations for instantiable child classes with properties.
  //

  BrushAction._();

  factory BrushAction([updates(BrushActionBuilder b)]) = _$BrushAction;
}

@immutable
abstract class EraserAction
    implements StrokeDrawingAction, Built<EraserAction, EraserActionBuilder> {
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

    _drawPoints(canvas, paint,
        points.map((offset) => Offset(offset.dx, offset.dy)).toList());
  }

  EraserAction._();

  factory EraserAction([updates(EraserActionBuilder b)]) = _$EraserAction;
}

//
// built_value doesn't work with flutter classes like Color and Offset - https://github.com/dart-lang/build/issues/733
// Need to make our own equivalent (or use the raw value)
//

@immutable
abstract class OffsetValue implements Built<OffsetValue, OffsetValueBuilder> {
  double get dx;

  double get dy;

  OffsetValue._();

  factory OffsetValue([updates(OffsetValueBuilder b)]) = _$OffsetValue;

  static OffsetValue from(Offset offset) => OffsetValue((b) => b
    ..dx = offset.dx
    ..dy = offset.dy);
}

//
// TODO Move these somewhere, a utils class.
//

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
