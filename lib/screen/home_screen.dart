import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/screen/note_screen.dart';
import 'package:notable/widget/notes_page.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title, @required this.onInit}) : super(key: key);

  final String title;

  // Function used to initial the data source
  final void Function() onInit;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotesBloc _notesBloc;

  void _openNoteEditor(BuildContext context) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BlocProvider<NotesBloc>(
                bloc: _notesBloc,
                child: AddEditNoteScreen(id: null),
              )));

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
      body: Padding(
          padding: EdgeInsets.all(16),
          child: BlocProvider<NotesBloc>(
            bloc: _notesBloc,
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
