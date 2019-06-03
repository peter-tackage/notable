import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notable/bloc/drawing/drawing_bloc.dart';
import 'package:notable/bloc/drawing/drawing_events.dart';
import 'package:notable/bloc/drawing/drawing_states.dart';
import 'package:notable/bloc/drawing_config/drawing_config_bloc.dart';
import 'package:notable/bloc/drawing_config/drawing_config_events.dart';
import 'package:notable/bloc/drawing_config/drawing_config_states.dart';
import 'package:notable/model/drawing_config.dart';

import 'note_painter.dart';

class DrawingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  DrawingBloc _drawingBloc;
  DrawingConfigBloc _drawingConfigBloc;

  @override
  void initState() {
    super.initState();
    _drawingBloc = BlocProvider.of<DrawingBloc>(context);
    _drawingConfigBloc = BlocProvider.of<DrawingConfigBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawingConfigEvent, DrawingConfigState>(
        bloc: _drawingConfigBloc,
        builder: (BuildContext context, DrawingConfigState configState) =>
            BlocBuilder<DrawingEvent, DrawingState>(
                bloc: BlocProvider.of<DrawingBloc>(context),
                builder: (BuildContext context, DrawingState drawingState) =>
                    Column(
                      children: <Widget>[
                        Expanded(
                            child: Container(
                                child: ConstrainedBox(
                                    constraints: const BoxConstraints.expand(),
                                    child: canvasBody(
                                        drawingState, configState)))),
                        _buildToolbar(context, drawingState)
                      ],
                    )));
  }

  Widget canvasBody(DrawingState drawingState, DrawingConfigState configState) {
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
            painter: NotePainter(drawingState.drawing.displayedActions),
          ));
    } else {
      throw Exception("Unsupported State: $drawingState $configState");
    }
  }

  // TODO Perform could be better if we didn't update this when only new points
  // were added. That change doesn't affect this.
  Widget _buildToolbar(BuildContext context, DrawingState state) {
    return Container(
        height: 64,
        child: Material(
            color: Colors.grey[200],
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                      child: IconButton(
                          tooltip: "Brush",
                          onPressed: _selectBrush,
                          icon: Icon(Icons.gesture))),
                  InkWell(
                      child: IconButton(
                          tooltip: "Color",
                          onPressed: () => {},
                          icon: Icon(Icons.palette))),
                  InkWell(
                      child: IconButton(
                          tooltip: "Eraser",
                          onPressed: _selectEraser,
                          icon: Icon(Icons.indeterminate_check_box))),
                  InkWell(
                      child: IconButton(
                          tooltip: "Undo",
                          onPressed:
                              state is DrawingLoaded && state.drawing.canUndo
                                  ? _undo
                                  : null,
                          icon: Icon(Icons.undo))),
                  InkWell(
                      child: IconButton(
                          tooltip: "Redo",
                          onPressed:
                              state is DrawingLoaded && state.drawing.canRedo
                                  ? _redo
                                  : null,
                          icon: Icon(Icons.redo))),
                  InkWell(
                      child: IconButton(
                          tooltip: "Clear",
                          onPressed:
                              state is DrawingLoaded && state.drawing.canUndo
                                  ? _clear
                                  : null,
                          icon: Icon(Icons.clear_all)))
                ])));
  }

  _undo() => _drawingBloc.dispatch(Undo());

  _redo() => _drawingBloc.dispatch(Redo());

  _clear() => _drawingBloc.dispatch(ClearDrawing());

  _onToolDown(DragStartDetails details, DrawingConfig config) => _drawingBloc
      .dispatch(StartDrawing(config, _globalToLocal(details.globalPosition)));

  _onToolMoved(DragUpdateDetails details) => _drawingBloc
      .dispatch(UpdateDrawing(_globalToLocal(details.globalPosition)));

  _onToolUp(DragEndDetails details) => _drawingBloc.dispatch(EndDrawing());

  Widget _buildLoadingIndicator() => Center(child: CircularProgressIndicator());

  _selectBrush() => _drawingConfigBloc.dispatch(SelectDrawingTool(Tool.Brush));

  _selectEraser() =>
      _drawingConfigBloc.dispatch(SelectDrawingTool(Tool.Eraser));

  Offset _globalToLocal(Offset global) {
    return (context.findRenderObject() as RenderBox).globalToLocal(global);
  }
}
