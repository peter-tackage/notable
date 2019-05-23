import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notable/bloc/feed/feed_bloc.dart';
import 'package:notable/bloc/feed/feed_events.dart';
import 'package:notable/bloc/feed/feed_states.dart';
import 'package:notable/model/base_note.dart';
import 'package:notable/model/checklist.dart';
import 'package:notable/model/text_note.dart';
import 'package:notable/screen/checklist_note_screen.dart';
import 'package:notable/screen/text_note_screen.dart';
import 'package:notable/widget/note_item.dart';

import 'checklist_note_item.dart';

class NotesPage extends StatelessWidget {
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

  Widget _buildNoteList(BuildContext context, List<Checklist> checklists) =>
      ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            _buildItem(checklists[index], index, context),
        itemCount: checklists.length,
      );

  Widget _buildItem(BaseNote note, int index, BuildContext context) {
    if (note is TextNote) {
      return NoteItemWidget(note, () => _openTextNote(context, note));
    } else if (note is Checklist) {
      return ChecklistNoteItem(
          checklist: note, onTap: () => _openChecklist(context, note));
    } else {
      throw Exception("Unsupported type: $note");
    }
  }

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
