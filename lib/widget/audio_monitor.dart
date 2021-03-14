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
    var paintOn = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.fill;

    var paintOff = Paint()
      ..color = Colors.grey[200]
      ..style = PaintingStyle.fill;

    final segmentCount = 6;
    final segmentWidth = 40;
    final gap = 5;
    final dbPerSegment = _peakDb / segmentCount;

    for (var segment = 0; segment <= segmentCount; segment++) {
      final double dxLeft = (segment * (segmentWidth + gap)).floorToDouble(); // ignore: omit_local_variable_types
      var maxSegmentDb = (segment) * dbPerSegment;

      var rect = Rect.fromPoints(
          Offset(dxLeft, 0), size.bottomLeft(Offset(dxLeft + segmentWidth, 0)));
      canvas.drawRect(rect, _level > maxSegmentDb ? paintOn : paintOff);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
