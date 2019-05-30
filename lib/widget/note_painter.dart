import 'package:flutter/widgets.dart';
import 'package:notable/model/drawing.dart';

class NotePainter extends CustomPainter {
  final List<DrawingAction> actions;

  NotePainter(this.actions);

  @override
  void paint(Canvas canvas, Size size) {
    actions.forEach((action) => action.draw(canvas));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
