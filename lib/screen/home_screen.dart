import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notable/bloc/feed/feed_bloc.dart';
import 'package:notable/bloc/feed/feed_events.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/entity/entity.dart';
import 'package:notable/l10n/localization.dart';
import 'package:notable/model/audio_note.dart';
import 'package:notable/model/checklist.dart';
import 'package:notable/model/drawing.dart';
import 'package:notable/model/text_note.dart';
import 'package:notable/screen/addedit_audio_note_screen.dart';
import 'package:notable/screen/addedit_checklist_note_screen.dart';
import 'package:notable/screen/addedit_drawing_note_screen.dart';
import 'package:notable/screen/addedit_text_note_screen.dart';
import 'package:notable/widget/all_notes_page.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: BlocProvider<FeedBloc>(
          builder: _feedBlocBuilder, child: AllNotesPage()),
      bottomNavigationBar: _buildBottomAppBar(context),
    );
  }

  FeedBloc _feedBlocBuilder(context) {
    return FeedBloc(
        textNotesBloc:
            BlocProvider.of<NotesBloc<TextNote, TextNoteEntity>>(context),
        checklistNotesBloc:
            BlocProvider.of<NotesBloc<Checklist, ChecklistEntity>>(context),
        drawingNotesBloc:
            BlocProvider.of<NotesBloc<Drawing, DrawingEntity>>(context),
        audioNotesBloc:
            BlocProvider.of<NotesBloc<AudioNote, AudioNoteEntity>>(context))
      ..dispatch(LoadFeed());
  }

  Widget _buildBottomAppBar(context) {
    return Container(
        child: Material(
      color: Colors.grey[200],
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
        InkWell(
            child: IconButton(
                tooltip:
                    NotableLocalizations.of(context).audio_note_create_tooltip,
                onPressed: () => _openAudioNoteEditor(context),
                icon: Icon(Icons.mic))),
        InkWell(
            child: IconButton(
                tooltip: NotableLocalizations.of(context)
                    .drawing_note_create_tooltip,
                onPressed: () => _openDrawingNoteEditor(context),
                icon: Icon(Icons.brush))),
        InkWell(
            child: IconButton(
                tooltip:
                    NotableLocalizations.of(context).text_note_create_tooltip,
                onPressed: () => _openTextNoteEditor(context),
                icon: Icon(Icons.format_quote))),
        InkWell(
            child: IconButton(
                tooltip:
                    NotableLocalizations.of(context).checklist_create_tooltip,
                onPressed: () => _openChecklistEditor(context),
                icon: Icon(Icons.format_list_bulleted)))
      ]),
    ));
  }

  void _openChecklistEditor(context) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddEditChecklistNoteScreen(id: null)));

  void _openTextNoteEditor(context) => Navigator.push(context,
      MaterialPageRoute(builder: (context) => AddEditTextNoteScreen(id: null)));

  void _openDrawingNoteEditor(context) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddEditDrawingNoteScreen(id: null)));

  void _openAudioNoteEditor(context) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddEditAudioNoteScreen(id: null)));
}
