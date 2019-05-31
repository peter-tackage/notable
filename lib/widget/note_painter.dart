import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notable/model/drawing.dart';

class NotePainter extends CustomPainter {
  final List<DrawingAction> actions;

  NotePainter(this.actions);

  @override
  void paint(Canvas canvas, Size size) {
    // FIXME This could be improved by committing the changes to the canvas and not redrawing everything.

    // Not really sure how this save/restore works, but doing this fixes the
    // eraser functionality. From https://github.com/flutter/flutter/issues/24466
    canvas.saveLayer(Offset.zero & size, Paint());
    actions.forEach((action) => action.draw(canvas));
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
