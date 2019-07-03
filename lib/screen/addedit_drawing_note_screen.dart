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

class AddEditDrawingNoteScreen extends StatelessWidget {
  final String id;

  AddEditDrawingNoteScreen({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notesBloc =
        BlocProvider.of<NotesBloc<Drawing, DrawingEntity>>(context);

    return BlocProviderTree(blocProviders: [
      BlocProvider<DrawingBloc>(
          builder: (BuildContext context) =>
              DrawingBloc(notesBloc: notesBloc, id: id)),
      BlocProvider<DrawingConfigBloc>(
          builder: (BuildContext context) => DrawingConfigBloc())
    ], child: _AddEditDrawingNoteScreenContent(id: id));
  }
}

class _AddEditDrawingNoteScreenContent extends StatelessWidget {
  final String id;

  _AddEditDrawingNoteScreenContent({Key key, this.id}) : super(key: key);

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Text("Drawing"), actions: _createMenuItems(context)),
        body: _buildBody(context),
        bottomNavigationBar: _buildBottomAppBar(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _saveDrawing(context),
          tooltip: 'Save drawing',
          child: Icon(Icons.check),
        ));
  }

  Widget _buildBody(context) {
    return BlocBuilder(
        bloc: _drawingBlocOf(context),
        builder: (BuildContext context, DrawingState state) {
          if (state is DrawingLoaded) {
            return Stack(children: [
              DrawingPage(),
              Form(
                  key: _formKey,
                  child: Padding(
                      padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                      child: TextFormField(
                          onSaved: (value) =>
                              _onSaveTitle(value, _drawingBlocOf(context)),
                          initialValue: state.drawing.title,
                          style: Theme.of(context).textTheme.title,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: 'Title...'),
                          maxLines: 1,
                          textCapitalization: TextCapitalization.sentences,
                          autofocus: false)))
            ]);
          } else {
            // FIXME This is duplicated in the DrawingPage
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  DrawingBloc _drawingBlocOf(context) => BlocProvider.of<DrawingBloc>(context);

  DrawingConfigBloc _drawingConfigBlocOf(context) =>
      BlocProvider.of<DrawingConfigBloc>(context);

  _saveDrawing(context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }

    _drawingBlocOf(context).dispatch(SaveDrawing());
    Navigator.pop(context);
  }

  _handleMenuItemSelection(menuItem, context) {
    if (menuItem == "delete") {
      _deleteNote(context);
    }
  }

  _deleteNote(context) {
    if (id != null) {
      _drawingBlocOf(context).dispatch(DeleteDrawing());
      Navigator.pop(context);
    }
  }

  _createMenuItems(context) {
    return id == null
        ? null
        : <Widget>[
            PopupMenuButton(
                onSelected: (value) => _handleMenuItemSelection(value, context),
                itemBuilder: (context) => [
                      PopupMenuItem(
                        value: "delete",
                        child: Text("Delete"),
                      )
                    ])
          ];
  }

  Widget _buildBottomAppBar(context) {
    return BlocBuilder<DrawingConfigEvent, DrawingConfigState>(
        bloc: _drawingConfigBlocOf(context),
        builder: (BuildContext context, DrawingConfigState configState) =>
            BlocBuilder<DrawingEvent, DrawingState>(
                bloc: _drawingBlocOf(context),
                builder: (BuildContext context, DrawingState drawingState) =>
                    BottomAppBar(
                        child: Material(
                            color: Colors.grey[200],
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: _buildBottomBarItems(
                                    configState, context, drawingState))))));
  }

  List<Widget> _buildBottomBarItems(DrawingConfigState configState,
      BuildContext context, DrawingState drawingState) {
    return <Widget>[
      InkWell(
          child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                      items: _buildToolStyleMenuItems(),
                      value: configState is DrawingConfigLoaded
                          ? _ToolStyle(configState.drawingConfig.penShape,
                              configState.drawingConfig.strokeWidth)
                          : null,
                      onChanged: (value) => _selectToolStyle(
                          value, _drawingConfigBlocOf(context)),
                      icon: Icon(Icons.line_weight))))),
      InkWell(
          child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                      isDense: true,
                      items: _buildColorMenuItems(),
                      value: configState is DrawingConfigLoaded
                          ? configState.drawingConfig.color
                          : null,
                      onChanged: (value) =>
                          _setToolColor(value, _drawingConfigBlocOf(context)),
                      icon: Icon(Icons.palette))))),
      InkWell(
          child: IconButton(
              tooltip: "Brush",
              onPressed: () => _selectBrush(_drawingConfigBlocOf(context)),
              icon: Icon(Icons.gesture))),
      InkWell(
          child: IconButton(
              tooltip: "Eraser",
              onPressed: () => _selectEraser(_drawingConfigBlocOf(context)),
              icon: Transform.rotate(angle: pi, child: Icon(Icons.create)))),
      InkWell(
          child: IconButton(
              tooltip: "Undo",
              onPressed:
                  drawingState is DrawingLoaded && drawingState.drawing.canUndo
                      ? () => _undo(_drawingBlocOf(context))
                      : null,
              icon: Icon(Icons.undo))),
      InkWell(
          child: IconButton(
              tooltip: "Redo",
              onPressed:
                  drawingState is DrawingLoaded && drawingState.drawing.canRedo
                      ? () => _redo(_drawingBlocOf(context))
                      : null,
              icon: Icon(Icons.redo))),
      InkWell(
          child: IconButton(
              tooltip: "Clear",
              onPressed:
                  drawingState is DrawingLoaded && drawingState.drawing.canUndo
                      ? () => _clear(_drawingBlocOf(context))
                      : null,
              icon: Icon(Icons.clear)))
    ];
  }

  _setToolColor(color, drawingConfigBloc) =>
      drawingConfigBloc.dispatch(SelectDrawingToolColor(color));

  _undo(drawingBloc) => drawingBloc.dispatch(Undo());

  _redo(drawingBloc) => drawingBloc.dispatch(Redo());

  _clear(drawingBloc) => drawingBloc.dispatch(ClearDrawing());

  _selectBrush(drawingConfigBloc) =>
      drawingConfigBloc.dispatch(SelectDrawingTool(Tool.Brush));

  _selectToolStyle(_ToolStyle toolStyle, drawingConfigBloc) {
    drawingConfigBloc
        .dispatch(SelectToolStyle(toolStyle.penShape, toolStyle.strokeWidth));
  }

  _selectEraser(drawingConfigBloc) =>
      drawingConfigBloc.dispatch(SelectDrawingTool(Tool.Eraser));

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

  _onSaveTitle(String newTitle, drawingBloc) =>
      drawingBloc.dispatch(UpdateDrawingTitle(newTitle));
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
