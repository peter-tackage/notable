import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notable/bloc/feed/feed_bloc.dart';
import 'package:notable/bloc/feed/feed_events.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/entity/entity.dart';
import 'package:notable/model/checklist.dart';
import 'package:notable/model/text_note.dart';
import 'package:notable/screen/checklist_note_screen.dart';
import 'package:notable/widget/notes_page.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  // Function used to initial the data source
  // final void Function() onInit;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FeedBloc _feedBloc;

  void _openNoteEditor(BuildContext context) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddEditChecklistNoteScreen(id: null)));

  @override
  void initState() {
    super.initState();

    _feedBloc = FeedBloc(
        textNotesBloc:
            BlocProvider.of<NotesBloc<TextNote, NoteEntity>>(context),
        checklistNotesBloc:
            BlocProvider.of<NotesBloc<Checklist, ChecklistEntity>>(context));
    _feedBloc.dispatch(LoadFeed());
    //  widget.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
          padding: EdgeInsets.all(16),
          child: BlocProvider<FeedBloc>(
            bloc: _feedBloc,
            child: NotesPage(),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openNoteEditor(context),
        tooltip: 'Add note',
        child: Icon(Icons.add),
      ),
    );
  }
}
