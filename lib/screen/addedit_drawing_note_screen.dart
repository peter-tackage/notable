import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notable/bloc/drawing/drawing_bloc.dart';
import 'package:notable/bloc/drawing/drawing_events.dart';
import 'package:notable/bloc/drawing/drawing_states.dart';
import 'package:notable/bloc/drawing_config/drawing_config_bloc.dart';
import 'package:notable/bloc/drawing_config/drawing_config_events.dart';
import 'package:notable/bloc/drawing_config/drawing_config_states.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/entity/drawing_entity.dart';
import 'package:notable/model/drawing.dart';
import 'package:notable/model/drawing_config.dart';
import 'package:notable/widget/drawing_page.dart';

class AddEditDrawingNoteScreen extends StatefulWidget {
  final String id;

  AddEditDrawingNoteScreen({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddEditDrawingNoteScreenState();
}

class _AddEditDrawingNoteScreenState extends State<AddEditDrawingNoteScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  NotesBloc<Drawing, DrawingEntity> _notesBloc;
  DrawingBloc _drawingBloc;
  DrawingConfigBloc _drawingConfigBloc;

  @override
  void initState() {
    super.initState();
    _notesBloc = BlocProvider.of<NotesBloc<Drawing, DrawingEntity>>(context);
    _drawingBloc = DrawingBloc(notesBloc: _notesBloc, id: widget.id);
    _drawingConfigBloc = DrawingConfigBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Drawing"), actions: _createMenuItems()),
        body: BlocProviderTree(blocProviders: [
          BlocProvider<DrawingBloc>(bloc: _drawingBloc),
          BlocProvider<DrawingConfigBloc>(bloc: _drawingConfigBloc)
        ], child: _buildBody()),
        bottomNavigationBar: _buildBottomAppBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: _saveDrawing,
          tooltip: 'Save drawing',
          child: Icon(Icons.check),
        ));
  }

  Widget _buildBody() {
    return BlocBuilder(
        bloc: _drawingBloc,
        builder: (BuildContext context, DrawingState state) {
          if (state is DrawingLoaded) {
            return Stack(children: [
              DrawingPage(),
              Form(
                  key: _formKey,
                  child: Padding(
                      padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                      child: TextFormField(
                          onSaved: _onSaveTitle,
                          initialValue: state.drawing.title,
                          style: Theme.of(context).textTheme.title,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: 'Title...'),
                          maxLines: 1,
                          textCapitalization: TextCapitalization.sentences,
                          autofocus: false)))
            ]);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  _saveDrawing() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }

    _drawingBloc.dispatch(SaveDrawing());
    Navigator.pop(context);
  }

  _handleMenuItemSelection(value) {
    if (value == "delete") {
      _deleteNote();
    }
  }

  _deleteNote() {
    if (widget.id != null) {
      _notesBloc.dispatch(DeleteNote(widget.id));
      Navigator.pop(context);
    }
  }

  _createMenuItems() {
    return widget.id == null
        ? null
        : <Widget>[
            PopupMenuButton(
                onSelected: _handleMenuItemSelection,
                itemBuilder: (context) => [
                      PopupMenuItem(
                        value: "delete",
                        child: Text("Delete"),
                      )
                    ])
          ];
  }

  Widget _buildBottomAppBar() {
    return BlocBuilder<DrawingConfigEvent, DrawingConfigState>(
        bloc: _drawingConfigBloc,
        builder: (BuildContext context, DrawingConfigState configState) =>
            BlocBuilder<DrawingEvent, DrawingState>(
                bloc: _drawingBloc,
                builder: (BuildContext context, DrawingState drawingState) =>
                    BottomAppBar(
                        child: Material(
                            color: Colors.grey[200],
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  InkWell(
                                      child: DropdownButtonHideUnderline(
                                          child: ButtonTheme(
                                              alignedDropdown: true,
                                              child: DropdownButton(
                                                  items:
                                                      _buildToolStyleMenuItems(),
                                                  value: configState
                                                          is DrawingConfigLoaded
                                                      ? _ToolStyle(
                                                          configState
                                                              .drawingConfig
                                                              .penShape,
                                                          configState
                                                              .drawingConfig
                                                              .strokeWidth)
                                                      : null,
                                                  onChanged: _selectToolStyle,
                                                  icon: Icon(
                                                      Icons.line_style))))),
                                  InkWell(
                                      child: DropdownButtonHideUnderline(
                                          child: ButtonTheme(
                                              alignedDropdown: true,
                                              child: DropdownButton(
                                                  isDense: true,
                                                  items: _buildColorMenuItems(),
                                                  value: configState
                                                          is DrawingConfigLoaded
                                                      ? configState
                                                          .drawingConfig
                                                          .color
                                                          .value
                                                      : null,
                                                  onChanged: _setToolColor,
                                                  icon: Icon(Icons.palette))))),
                                  InkWell(
                                      child: IconButton(
                                          tooltip: "Brush",
                                          onPressed: _selectBrush,
                                          icon: Icon(Icons.gesture))),
                                  InkWell(
                                      child: IconButton(
                                          tooltip: "Eraser",
                                          onPressed: _selectEraser,
                                          icon: Transform.rotate(
                                              angle: pi,
                                              child: Icon(Icons.create)))),
                                  InkWell(
                                      child: IconButton(
                                          tooltip: "Undo",
                                          onPressed: drawingState
                                                      is DrawingLoaded &&
                                                  drawingState.drawing.canUndo
                                              ? _undo
                                              : null,
                                          icon: Icon(Icons.undo))),
                                  InkWell(
                                      child: IconButton(
                                          tooltip: "Redo",
                                          onPressed: drawingState
                                                      is DrawingLoaded &&
                                                  drawingState.drawing.canRedo
                                              ? _redo
                                              : null,
                                          icon: Icon(Icons.redo))),
                                  InkWell(
                                      child: IconButton(
                                          tooltip: "Clear",
                                          onPressed: drawingState
                                                      is DrawingLoaded &&
                                                  drawingState.drawing.canUndo
                                              ? _clear
                                              : null,
                                          icon: Icon(Icons.clear)))
                                ])))));
  }

  _setToolColor(color) =>
      _drawingConfigBloc.dispatch(SelectDrawingToolColor(color));

  _undo() => _drawingBloc.dispatch(Undo());

  _redo() => _drawingBloc.dispatch(Redo());

  _clear() => _drawingBloc.dispatch(ClearDrawing());

  _selectBrush() => _drawingConfigBloc.dispatch(SelectDrawingTool(Tool.Brush));

  _selectToolStyle(_ToolStyle toolStyle) {
    _drawingConfigBloc
        .dispatch(SelectToolStyle(toolStyle.penShape, toolStyle.strokeWidth));
  }

  _selectEraser() =>
      _drawingConfigBloc.dispatch(SelectDrawingTool(Tool.Eraser));

  List<DropdownMenuItem<int>> _buildColorMenuItems() {
    return availableColors
        .map((color) => DropdownMenuItem(
            value: color.value,
            child: Container(
                color: color, child: SizedBox(width: 15, height: 15))))
        .toList();
  }

  List<DropdownMenuItem<_ToolStyle>> _buildToolStyleMenuItems() {
    return availableToolStyles
        .map((toolStyle) => DropdownMenuItem(
            value: toolStyle,
            child: Container(
              decoration: _decorationOf(toolStyle),
              width: toolStyle.strokeWidth,
              height: toolStyle.strokeWidth,
            )))
        .toList();
  }

  BoxDecoration _decorationOf(_ToolStyle toolStyle) =>
      toolStyle.penShape == PenShape.Square
          ? BoxDecoration(shape: BoxShape.rectangle, color: Colors.black)
          : BoxDecoration(shape: BoxShape.circle, color: Colors.black);

  _onSaveTitle(String newTitle) =>
      _drawingBloc.dispatch(UpdateDrawingTitle(newTitle));
}

class _ToolStyle {
  final PenShape penShape;
  final double strokeWidth;

  _ToolStyle(this.penShape, this.strokeWidth);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ToolStyle &&
          runtimeType == other.runtimeType &&
          penShape == other.penShape &&
          strokeWidth == other.strokeWidth;

  @override
  int get hashCode => penShape.hashCode ^ strokeWidth.hashCode;
}

final availableToolStyles = <_ToolStyle>[
  _ToolStyle(PenShape.Square, 20),
  _ToolStyle(PenShape.Square, 10),
  _ToolStyle(PenShape.Square, 5),
  _ToolStyle(PenShape.Round, 20),
  _ToolStyle(PenShape.Round, 10),
  _ToolStyle(PenShape.Round, 5)
];

final List<Color> availableColors = [
  ...Colors.primaries,
  Colors.black,
  Colors.white
];
