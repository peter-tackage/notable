import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AudioMonitor extends StatefulWidget {
  final double peakDb;
  final double level;

  AudioMonitor({@required this.peakDb, @required this.level});

  @override
  State<StatefulWidget> createState() => _AudioMonitorState();
}

class _AudioMonitorState extends State<AudioMonitor> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 300,
        height: 20,
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

    final double segmentCount = 6;
    final double segmentWidth = 40;
    final double gap = 5;
    double dxLeft = 0;
    final double dbPerSegment = _peakDb / segmentCount;

    for (int segment = 0; segment <= segmentCount; segment++) {
      dxLeft = segment * (segmentWidth + gap);
      double maxSegmentDb = (segment) * dbPerSegment;

      Rect rect = Rect.fromPoints(
          Offset(dxLeft, 0), size.bottomLeft(Offset(dxLeft + segmentWidth, 0)));
      canvas.drawRect(rect, _level > maxSegmentDb ? paintOn : paintOff);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
