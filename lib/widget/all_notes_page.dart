import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notable/bloc/feed/feed_bloc.dart';
import 'package:notable/bloc/feed/feed_events.dart';
import 'package:notable/bloc/feed/feed_states.dart';
import 'package:notable/model/base_note.dart';
import 'package:notable/model/checklist.dart';
import 'package:notable/model/drawing.dart';
import 'package:notable/model/text_note.dart';
import 'package:notable/screen/addedit_checklist_note_screen.dart';
import 'package:notable/screen/addedit_drawing_note_screen.dart';
import 'package:notable/screen/addedit_text_note_screen.dart';
import 'package:notable/widget/drawing_card_item.dart';
import 'package:notable/widget/note_card_item.dart';

import 'checklist_card_item.dart';

class AllNotesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedEvent, FeedState>(
      bloc: BlocProvider.of<FeedBloc>(context),
      builder: (BuildContext context, FeedState feedState) {
        if (feedState is FeedLoading) {
          return _buildLoadingIndicator();
        } else if (feedState is FeedLoaded) {
          return feedState.feed.isEmpty
              ? _buildEmptyNoteList(context)
              : _buildNoteList(context, feedState.feed);
        }
      },
    );
  }

  Widget _buildLoadingIndicator() => Center(child: CircularProgressIndicator());

  Widget _buildNoteList(BuildContext context, List<BaseNote> checklists) =>
      ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            _buildItem(checklists[index], index, context),
        itemCount: checklists.length,
      );

  Widget _buildItem(BaseNote note, int index, BuildContext context) {
    if (note is TextNote) {
      return NoteCardItem(
          note: note, onTap: () => _openTextNote(context, note));
    } else if (note is Checklist) {
      return ChecklistNoteCardItem(
          checklist: note, onTap: () => _openChecklist(context, note));
    } else if (note is Drawing) {
      return DrawingCardItem(
          drawing: note, onTap: () => _openDrawing(context, note));
    } else {
      throw Exception("Unsupported Note type: $note");
    }
  }

  static _openTextNote(BuildContext context, TextNote note) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddEditTextNoteScreen(id: note.id)),
      );

  static _openChecklist(BuildContext context, Checklist checklist) =>
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddEditChecklistNoteScreen(id: checklist.id)),
      );

  static _openDrawing(BuildContext context, Drawing drawing) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddEditDrawingNoteScreen(id: drawing.id)),
      );

  static Widget _buildEmptyNoteList(BuildContext context) => Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Icon(
              Icons.assignment,
              size: 100.0,
              color: Colors.blueGrey[200],
            ),
            Text("You don't have any notes yet")
          ]));
}
