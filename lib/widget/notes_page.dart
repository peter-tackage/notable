import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/model/base_note.dart';
import 'package:notable/model/text_note.dart';
import 'package:notable/screen/text_note_screen.dart';

class NotesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesEvent, NotesState>(
      bloc: BlocProvider.of<NotesBloc>(context),
      builder: (BuildContext context, NotesState notesState) {
        if (notesState is NotesLoading) {
          return _buildLoadingIndicator();
        } else if (notesState is NotesLoaded) {
          return notesState.notes.isEmpty
              ? _buildEmptyNoteList(context)
              : _buildNoteList(context, notesState.notes);
        }
      },
    );
  }

  Widget _buildLoadingIndicator() => Center(child: CircularProgressIndicator());

  Widget _buildNoteList(BuildContext context, List<BaseNote> notes) =>
      ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            Container(child: Text(notes[index].title ?? 'No title')),
        //  child: NoteItemWidget(
        //      notes[index], () => _openNote(context, notes[index]))),
        itemCount: notes.length,
      );

  void _openNote(BuildContext context, TextNote note) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddEditTextNoteScreen(id: note.id)),
    );
  }

  Widget _buildEmptyNoteList(BuildContext context) =>
      Center(child: Text("You don't have any notes"));
}
