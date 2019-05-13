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
        if (notesState is NotesLoading) {
          return _buildLoadingIndicator();
        } else if (notesState is NotesLoaded) {
          return _buildNoteList(context, notesState.notes);
        }
      },
    );
  }

  Widget _buildLoadingIndicator() => Center(child: CircularProgressIndicator());

  Widget _buildNoteList(BuildContext context, List<Note> notes) =>
      ListView.builder(
        itemBuilder: (BuildContext context, int index) => Container(
            child: NoteItemWidget(notes[index], () => _openNote(notes[index]))),
        itemCount: notes.length,
      );

  void _openNote(Note note) {
//    Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => NoteScreen(note)),
//    );
  }
}
