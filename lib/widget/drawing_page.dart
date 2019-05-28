import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DrawingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DrawingPageState();
}

abstract class Action {
  void draw(Canvas canvas);
}

class TextAction extends Action {
  final String text;
  final int sizeFactor;
  final Color color;
  final Offset offset;

  TextAction(this.text, this.sizeFactor, this.color, this.offset) : super();

  @override
  void draw(Canvas canvas) {
    TextPainter painter = TextPainter(text: TextSpan(text: text));
    painter.paint(canvas, offset);
  }
}

class BrushAction extends Action {
  final List<Offset> points;
  final Color color;

  BrushAction(this.points, this.color, instrument) : super();

  @override
  void draw(Canvas canvas) {
    Paint paint = Paint();
    paint.strokeWidth = 5;
    paint.color = color;

    for (int index = 0; index < points.length - 1; index++) {
      Offset from = points[index];
      Offset to = points[index + 1];

      if (from != null && to != null) {
        canvas.drawLine(from, to, paint);
      }
    }
  }
}

enum Tool { Brush, Text, Eraser }

class _DrawingPageState extends State<DrawingPage> {
  List<Action> actions = List();
  int lastIndex = -1;

  Tool instrument = Tool.Brush;
  Color color = Colors.blue;

  @override
  Widget build(BuildContext context) {
    print("BUILD: until $lastIndex");
    return Column(
      children: <Widget>[
        Expanded(
            child: ConstrainedBox(
                constraints: const BoxConstraints.expand(),
                child: GestureDetector(
                    onHorizontalDragStart: _toolDown,
                    onHorizontalDragUpdate: _toolMoved,
                    onHorizontalDragEnd: _toolUp,
                    child: CustomPaint(
                      painter: NotePainter(_drawable(actions, lastIndex)),
                    )))),
        Container(
          height: 64,
          color: Colors.grey[200],
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(
                    tooltip: "Brush",
                    onPressed: () => {},
                    icon: Icon(Icons.brush)),

//                IconButton(
//                    tooltip: "Text",
//                    onPressed: () => {},
//                    icon: Icon(Icons.text_fields)),
                IconButton(
                    tooltip: "Color",
                    onPressed: () => {},
                    icon: Icon(Icons.palette)),
                IconButton(
                    tooltip: "Undo",
                    onPressed: lastIndex < 0 ? null : _undo,
                    icon: Icon(Icons.undo)),
                IconButton(
                    tooltip: "Redo",
                    onPressed: lastIndex == actions.length - 1 ? null : _redo,
                    icon: Icon(Icons.redo))
              ]),
        ),
      ],
    );
  }

  static List<Action> _drawable(List<Action> actions, int lastIndex) {
    List<Action> todo = actions.sublist(0, lastIndex + 1);
    return todo;
  }

  void _toolDown(DragStartDetails details) {
    print("_penDown: lastIndex: ${lastIndex}, length: ${actions.length}");
    // Configure new action
    setState(() {
      Action action =
          BrushAction(<Offset>[details.globalPosition], color, instrument);

      //
      if (lastIndex >= 0 && lastIndex != actions.length - 1) {
        print("#### DISCARDING ITEMS");
        actions = actions.sublist(0, lastIndex + 1);
      }
      actions.add(action);
      lastIndex = actions.length - 1;

      print("AFTER: lastIndex: ${lastIndex}, length: ${actions.length}");
    });
  }

  void _toolMoved(DragUpdateDetails details) {
    // Add to currentAction
    setState(() {
      Action action = actions[lastIndex];

      if (action is BrushAction) {
        action.points.add(details.globalPosition);
      }
    });
  }

  void _toolUp(DragEndDetails details) {
    print("_penUp");
  }

  void _undo() {
    setState(() {
      print("Undoing");
      lastIndex--;
    });
  }

  void _redo() {
    setState(() {
      print("Redoing");
      lastIndex++;
    });
  }
}

class NotePainter extends CustomPainter {
  final List<Action> actions;

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
