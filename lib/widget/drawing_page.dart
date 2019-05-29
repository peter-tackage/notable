import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notable/bloc/drawing/drawing_bloc.dart';
import 'package:notable/bloc/drawing/drawing_events.dart';
import 'package:notable/bloc/drawing/drawing_states.dart';
import 'package:notable/bloc/drawing_config/drawing_config_bloc.dart';
import 'package:notable/bloc/drawing_config/drawing_config_events.dart';
import 'package:notable/bloc/drawing_config/drawing_config_states.dart';
import 'package:notable/model/drawing.dart';
import 'package:notable/model/drawing_config.dart';

class DrawingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  DrawingBloc _drawingBloc;
  DrawingConfigBloc _drawingConfigBloc;

  @override
  void initState() {
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
                            child: ConstrainedBox(
                                constraints: const BoxConstraints.expand(),
                                child: canvasBody(drawingState, configState))),
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
          onHorizontalDragStart: (details) =>
              _onToolDown(details, configState.drawingConfig),
          onHorizontalDragUpdate: _onToolMoved,
          onHorizontalDragEnd: _onToolUp,
          child: CustomPaint(
            painter: NotePainter(drawingState.drawing.displayedActions),
          ));
    }
  }

  // TODO Perform could be better if we didn't update this when only new points
  // were added. That change doesn't affect this.
  Widget _buildToolbar(BuildContext context, DrawingState state) {
    return Container(
        height: 64,
        color: Colors.grey[200],
        child:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          IconButton(
              tooltip: "Brush", onPressed: () => {}, icon: Icon(Icons.brush)),
          IconButton(
              tooltip: "Color", onPressed: () => {}, icon: Icon(Icons.palette)),
          IconButton(
              tooltip: "Undo",
              onPressed: state is DrawingLoaded && state.drawing.canUndo
                  ? _undo
                  : null,
              icon: Icon(Icons.undo)),
          IconButton(
              tooltip: "Redo",
              onPressed: state is DrawingLoaded && state.drawing.canRedo
                  ? _redo
                  : null,
              icon: Icon(Icons.redo)),
          IconButton(
              tooltip: "Clear",
              onPressed: state is DrawingLoaded && state.drawing.canUndo
                  ? _clear
                  : null,
              icon: Icon(Icons.clear_all))
        ]));
  }

  _undo() => _drawingBloc.dispatch(Undo());

  _redo() => _drawingBloc.dispatch(Redo());

  _clear() => _drawingBloc.dispatch(ClearDrawing());

  _onToolDown(DragStartDetails details, DrawingConfig config) {
    print("###################3");
    _drawingBloc.dispatch(StartDrawing(config, details.globalPosition));
  }

  _onToolMoved(DragUpdateDetails details) {
    _drawingBloc.dispatch(UpdateDrawing(details.globalPosition));
  }

  _onToolUp(DragEndDetails details) {
    _drawingBloc.dispatch(EndDrawing());
  }

  Widget _buildLoadingIndicator() => Center(child: CircularProgressIndicator());
}

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
