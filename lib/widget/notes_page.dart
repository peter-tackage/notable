import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/model/note.dart';
import 'package:notable/widget/note_item.dart';

class NotesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final NotesBloc _notesBloc = BlocProvider.of<NotesBloc>(context);

    return BlocBuilder<NotesEvent, NotesState>(
      bloc: _notesBloc,
      builder: (BuildContext context, NotesState notesState) {
        if (notesState.isLoading) {
          return Center(child: Text("Loading"));
        } else {
          return _buildNoteList(context, notesState.notes);
        }
      },
    );
  }

  void _openNote(Note note) {
//    Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => NoteScreen(note)),
//    );
  }

  Widget _buildNoteList(BuildContext context, List<Note> notes) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) => Container(
          child: NoteItemWidget(notes[index], () => _openNote(notes[index]))),
      itemCount: notes.length,
    );
  }
}
