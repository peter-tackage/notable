import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notable/bloc/drawing/drawing_bloc.dart';
import 'package:notable/bloc/drawing_config/drawing_config_bloc.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/entity/drawing_entity.dart';
import 'package:notable/model/drawing.dart';
import 'package:notable/widget/drawing_page.dart';

class AddEditDrawingNoteScreen extends StatefulWidget {
  final String id;

  AddEditDrawingNoteScreen({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddEditDrawingNoteScreenState();
}

class _AddEditDrawingNoteScreenState extends State<AddEditDrawingNoteScreen> {
  DrawingBloc _drawingBloc;
  DrawingConfigBloc _drawingConfigBloc;

  @override
  void initState() {
    super.initState();
    NotesBloc<Drawing, DrawingEntity> _notesBloc =
        BlocProvider.of<NotesBloc<Drawing, DrawingEntity>>(context);

    _drawingBloc = DrawingBloc(notesBloc: _notesBloc, id: widget.id);
    _drawingConfigBloc = DrawingConfigBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Drawing")),
        body: BlocProviderTree(blocProviders: [
          BlocProvider<DrawingBloc>(bloc: _drawingBloc),
          BlocProvider<DrawingConfigBloc>(bloc: _drawingConfigBloc)
        ], child: DrawingPage()),
        floatingActionButton: FloatingActionButton(
          onPressed: _saveDrawing,
          tooltip: 'Save drawing',
          child: Icon(Icons.check),
        ));
  }

  void _saveDrawing() {}
}
