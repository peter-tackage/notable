import 'dart:ui';

import 'package:meta/meta.dart';
import 'package:notable/model/base_note.dart';

@immutable
class Drawing extends BaseNote {
  final List<DrawingAction> allActions;
  final int currentIndex;

  // Derived - SHOULD THESE BE CALCULATED HERE
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

enum Tool { Brush, Text, Eraser }

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
    Paint paint = Paint();
    paint.strokeWidth = 5;
    final style = PaintingStyle.stroke;
    paint.style = style;
    paint.strokeCap = StrokeCap.round;
    paint.strokeJoin = StrokeJoin.round;
    paint.color = color;
    paint.isAntiAlias = true;

    for (int index = 0; index < points.length - 1; index++) {
      Offset from = points[index];
      Offset to = points[index + 1];
      canvas.drawLine(from, to, paint);
    }
  }

  @override
  String toString() => "BrushAction: ${points.length}";

  BrushAction copyWith(List<Offset> points) {
    return BrushAction(points, this.color);
  }
}
