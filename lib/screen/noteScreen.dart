import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notable/model/note.dart';

class NoteScreen extends StatelessWidget {
  final Note _note;

  NoteScreen(this._note);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("Note: ${_note.title}")), body: null);
  }
}
