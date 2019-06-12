import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notable/model/drawing.dart';
import 'package:notable/widget/note_painter.dart';

import 'note_card.dart';

class DrawingCardItem extends StatelessWidget {
  final Drawing drawing;
  final Function onTap;

  DrawingCardItem({@required this.drawing, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    // TODO Not sure yet how to draw this thing. Want to show a "highlight"
    // segment of the drawing. How to find that? How to clip?

    return NoteCard(
      note: drawing,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: CustomPaint(
                painter: NotePainter(drawing.displayedActions),
              ))),
      onTap: onTap,
    );
  }
}
