import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notable/bloc/drawing/drawing_bloc.dart';
import 'package:notable/bloc/drawing/drawing_events.dart';
import 'package:notable/bloc/drawing/drawing_states.dart';
import 'package:notable/bloc/drawing_config/drawing_config_bloc.dart';
import 'package:notable/bloc/drawing_config/drawing_config_states.dart';
import 'package:notable/model/drawing.dart';
import 'package:notable/model/drawing_config.dart';

import 'note_painter.dart';

class DrawingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawingConfigBloc, DrawingConfigState>(
        builder: (BuildContext context, DrawingConfigState configState) =>
            BlocBuilder<DrawingBloc, DrawingState>(
                builder: (BuildContext context, DrawingState drawingState) =>
                    Container(
                        child: ConstrainedBox(
                            constraints: const BoxConstraints.expand(),
                            child: _buildBody(drawingState, configState)))));
  }

  Widget _buildBody(DrawingState drawingState, DrawingConfigState configState) {
    if (drawingState is DrawingLoading) {
      return _buildLoadingIndicator();
    } else if (drawingState is DrawingLoaded &&
        configState is DrawingConfigLoaded) {
      return GestureDetector(
          onPanStart: (details) =>
              _onToolDown(details, configState.drawingConfig),
          onPanUpdate: _onToolMoved,
          onPanEnd: _onToolUp,
          child: CustomPaint(
              painter: NotePainter(drawingState.drawing.displayedActions)));
    } else {
      throw Exception("Unsupported State: $drawingState $configState");
    }
  }

  DrawingBloc _drawingBlocOf(context) => BlocProvider.of<DrawingBloc>(context);

  _onToolDown(DragStartDetails details, DrawingConfig config) =>
      _drawingBlocOf(context).dispatch(StartDrawing(
          config, OffsetValue.from(_globalToLocal(details.globalPosition))));

  _onToolMoved(DragUpdateDetails details) => _drawingBlocOf(context).dispatch(
      UpdateDrawing(OffsetValue.from(_globalToLocal(details.globalPosition))));

  _onToolUp(DragEndDetails details) =>
      _drawingBlocOf(context).dispatch(EndDrawing());

  Widget _buildLoadingIndicator() => Center(child: CircularProgressIndicator());

  Offset _globalToLocal(Offset global) =>
      (context.findRenderObject() as RenderBox).globalToLocal(global);
}
