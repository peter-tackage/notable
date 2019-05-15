import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/model/note.dart';
import 'package:notable/widget/note_add_edit_page.dart';

class AddEditNoteScreen extends StatefulWidget {
  final String id;

  AddEditNoteScreen({Key key, this.id}) : super(key: key);

  @override
  State createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  NotesBloc _notesBloc;

  Note _savedNote;
  String _task;
  String _content;

  @override
  void initState() {
    super.initState();
    _notesBloc = BlocProvider.of<NotesBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Note"),
        ),
        body: Padding(
            padding: EdgeInsets.all(16),
            child: BlocBuilder(
                bloc: _notesBloc,
                builder: (BuildContext context, NotesState state) {
                  final note = (state as NotesLoaded).notes.firstWhere(
                      (note) => note.id == widget.id,
                      orElse: () => null);
                  this._savedNote = note;
                  return Form(
                      key: _formKey,
                      child: NoteAddEditPage(note,
                          onSaveTitleCallback: (value) => _task = value,
                          onSaveContentCallback: (value) => _content = value));
                })),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _saveNote(context),
          tooltip: 'Save note',
          child: Icon(Icons.check),
        ));
  }

  _saveNote(BuildContext context) {

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }

    if (_savedNote == null) {
      Note created = Note(_task, _content, new List());
      _notesBloc.dispatch(AddNote(created));
    } else {
      Note updated = _savedNote.copyWith(_task, _content);
      _notesBloc.dispatch(UpdateNote(updated));
    }
    Navigator.pop(context);
  }
}
