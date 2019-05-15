import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/widget/note_add_edit_page.dart';

class AddEditNoteScreen extends StatelessWidget {
  final String id;

  AddEditNoteScreen({Key key, @required this.id}) : super(key: key);

  AddEditNoteScreen.newNote({Key key, this.id = null}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notesBloc = BlocProvider.of<NotesBloc>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Note"),
        ),
        body: Padding(
            padding: EdgeInsets.all(16),
            child: BlocBuilder(
                bloc: notesBloc,
                builder: (BuildContext context, NotesState state) {
                  final note = (state as NotesLoaded).notes.firstWhere(
                      (note) => note.id == this.id,
                      orElse: () => null);
                  return NoteAddEditPage(note);
                })),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _saveNote(context),
          tooltip: 'Save note',
          child: Icon(Icons.check),
        ));
  }

  _saveNote(BuildContext context) {
    // TODO Dispatch
  }
}
