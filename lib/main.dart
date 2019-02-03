import 'package:flutter/material.dart';
import 'package:notable/model/note.dart';
import 'package:notable/screen/noteScreen.dart';
import 'package:notable/widget/noteItem.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Noteable',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new NoteListPage(title: 'Noteable'),
    );
  }
}

class NoteListPage extends StatefulWidget {
  NoteListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NoteListPageState createState() => new _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  List<Note> _notes = List();

  void _createNewNote() {
    // TODO Open the new note screen (details)
    _notes.add(new Note(
        "title", "content", <String>["label1", "label2"], DateTime.now()));
    setState(() {
      _notes = _notes;
    });
  }

  void _openNote(Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteScreen(note)),
    );
  }

  Widget _noteRowBuilder(context, i) =>
      Container(child: NoteItemWidget(_notes[i], () =>_openNote(_notes[i])));

  Widget _buildNoteList(BuildContext context) => ListView.builder(
        itemBuilder: _noteRowBuilder,
        itemCount: _notes.length,
      );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: _buildNoteList(context),
      floatingActionButton: new FloatingActionButton(
        onPressed: _createNewNote,
        tooltip: 'Add note',
        child: new Icon(Icons.add),
      ),
    );
  }
}
