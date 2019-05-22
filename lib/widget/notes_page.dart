import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/model/checklist.dart';
import 'package:notable/model/text_note.dart';
import 'package:notable/screen/checklist_note_screen.dart';
import 'package:notable/screen/text_note_screen.dart';

import 'checklist_note_item.dart';

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

  Widget _buildNoteList(BuildContext context, List<Checklist> checklists) =>
      ListView.builder(
        itemBuilder: (BuildContext context, int index) => ChecklistNoteItem(
            checklist: checklists[index],
            onTap: () => _openChecklist(context, checklists[index])),
        // TODO Handle hetrogeneous types
        //  child: NoteItemWidget(
        //      notes[index], () => _openNote(context, notes[index]))),
        itemCount: checklists.length,
      );

  void _openTextNote(BuildContext context, TextNote note) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddEditTextNoteScreen(id: note.id)),
    );
  }

  void _openChecklist(BuildContext context, Checklist checklist) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddEditChecklistNoteScreen(id: checklist.id)),
    );
  }

  Widget _buildEmptyNoteList(BuildContext context) =>
      Center(child: Text("You don't have any notes"));
}
