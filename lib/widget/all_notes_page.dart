import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notable/bloc/feed/feed_bloc.dart';
import 'package:notable/bloc/feed/feed_states.dart';
import 'package:notable/l10n/localization.dart';
import 'package:notable/model/audio_note.dart';
import 'package:notable/model/base_note.dart';
import 'package:notable/model/checklist.dart';
import 'package:notable/model/drawing.dart';
import 'package:notable/model/text_note.dart';
import 'package:notable/screen/addedit_audio_note_screen.dart';
import 'package:notable/screen/addedit_checklist_note_screen.dart';
import 'package:notable/screen/addedit_drawing_note_screen.dart';
import 'package:notable/screen/addedit_text_note_screen.dart';
import 'package:notable/widget/audio_note_card_item.dart';
import 'package:notable/widget/drawing_card_item.dart';
import 'package:notable/widget/note_card_item.dart';

import 'checklist_card_item.dart';

class AllNotesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedState>(
      builder: (BuildContext context, FeedState feedState) {
        if (feedState is FeedLoading) {
          return _buildLoadingIndicator();
        } else if (feedState is FeedLoaded) {
          return feedState.feed.isEmpty
              ? _buildNoNotesWidget(context)
              : _buildNoteList(context, feedState.feed);
        } else {
          throw Exception("Unsupported FeedState: $feedState");
        }
      },
    );
  }

  static Widget _buildLoadingIndicator() => Center(child: CircularProgressIndicator());

  static Widget _buildNoteList(BuildContext context, List<BaseNote> notes) =>
           ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                _buildItem(notes[index], index, context),
            itemCount: notes.length,
          );

  static Widget _buildItem(BaseNote note, int index, BuildContext context) {
    if (note is TextNote) {
      return NoteCardItem(
          note: note, onTap: () => _openTextNote(context, note));
    } else if (note is Checklist) {
      return ChecklistNoteCardItem(
          checklist: note, onTap: () => _openChecklist(context, note));
    } else if (note is Drawing) {
      return DrawingCardItem(
          drawing: note, onTap: () => _openDrawing(context, note));
    } else if (note is AudioNote) {
      return AudioNoteCardItem(
          audioNote: note, onTap: () => _openAudioNote(context, note));
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

  static _openAudioNote(BuildContext context, AudioNote audioNote) =>
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddEditAudioNoteScreen(id: audioNote.id)),
      );

  static Widget _buildNoNotesWidget(BuildContext context) => Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Icon(
              Icons.assignment,
              size: 100.0,
              color: Colors.blueGrey[200],
            ),
            Text(NotableLocalizations.of(context).no_notes_msg,
                style: TextStyle(color: Colors.blueGrey))
          ]));
}
