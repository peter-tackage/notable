import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CircularAudioMonitor extends StatefulWidget {
  final double peakDb;
  final double level;

  CircularAudioMonitor({@required this.peakDb, @required this.level});

  @override
  State<StatefulWidget> createState() => _AudioMonitorState();
}

class _AudioMonitorState extends State<CircularAudioMonitor> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 100,
        height: 100,
        child: CustomPaint(
          painter: _AudioMonitorPainter(widget.peakDb, widget.level),
        ));
  }
}

class _AudioMonitorPainter extends CustomPainter {
  final double _level;
  final double _peakDb;

  _AudioMonitorPainter(this._peakDb, this._level);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paintOn = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.fill;

    Paint paintOff = Paint()
      ..color = Colors.grey[200]
      ..style = PaintingStyle.fill;

    Random random = Random();
    double radius = 50 * (_level / _peakDb) + random.nextInt(5);
    if (radius > 50) radius = 50;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 50, paintOff);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paintOn);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
