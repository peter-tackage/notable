import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/model/base_note.dart';
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

  Note _existingNote;
  String _title;
  String _text;

  @override
  void initState() {
    super.initState();
    _notesBloc = BlocProvider.of<NotesBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Note"), actions: <Widget>[
          PopupMenuButton(
              onCanceled: () => print("Cancelled"),
              onSelected: _handleMenuItemSelection,
              itemBuilder: (context) => [
                    PopupMenuItem(
                      value: "delete",
                      child: Text("Delete"),
                    )
                  ])
        ]),
        body: Padding(
            padding: EdgeInsets.all(16),
            child: BlocBuilder(
                bloc: _notesBloc,
                builder: (BuildContext context, NotesState state) {
                  final note = (state as NotesLoaded).notes.firstWhere(
                      (note) => note.id == widget.id,
                      orElse: () => null);
                  _existingNote = note;
                  return Form(
                      key: _formKey,
                      child: NoteAddEditPage(note,
                          onSaveTitleCallback: _updateTitle,
                          onSaveContentCallback: _updateContent));
                })),
        floatingActionButton: FloatingActionButton(
          onPressed: _saveNote,
          tooltip: 'Save note',
          child: Icon(Icons.check),
        ));
  }

  void _updateContent(value) => _text = value;

  void _updateTitle(value) => _title = value;

  _saveNote() {
    print("Saving");

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }

    // Create or update
    if (_existingNote == null) {
      _notesBloc.dispatch(AddNote(Note(_title, new List<Label>(), _text)));
    } else {
      _notesBloc.dispatch(UpdateNote(_existingNote.copyWith(_title, _text)));
    }

    Navigator.pop(context);
  }

  void _handleMenuItemSelection(value) {
    if (value == "delete") {
      _deleteNote(value);
    }
  }

  void _deleteNote(value) {
    print("Deleting: $value $_existingNote");
    _notesBloc.dispatch(DeleteNote(_existingNote.id));
    Navigator.pop(context);
  }
}
