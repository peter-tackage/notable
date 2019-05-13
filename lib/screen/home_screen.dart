import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/model/note.dart';
import 'package:notable/widget/notes_page.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title, @required this.onInit}) : super(key: key);

  final String title;
  final void Function() onInit;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotesBloc _notesBloc;

  void _createNewNote() {
    _notesBloc.dispatch(AddNote(
        Note("This is the title", "A new note", List(), DateTime.now())));
  }

  @override
  void initState() {
    _notesBloc = BlocProvider.of<NotesBloc>(context);
    widget.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocProvider<NotesBloc>(
        bloc: _notesBloc,
        child: NotesPage(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewNote,
        tooltip: 'Add note',
        child: Icon(Icons.add),
      ),
    );
  }
}
