import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notable/model/note.dart';

// TODO Can probably be stateless
class NoteAddEditPage extends StatefulWidget {
  final Note _note;

  NoteAddEditPage(this._note);

  @override
  State<StatefulWidget> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<NoteAddEditPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: TextFormField(
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Task...'),
              autofocus: true)),
      Expanded(
          child: Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: TextFormField(
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Enter your note...'),
                  maxLines: null,
                  keyboardType: TextInputType.multiline))),
      Padding(padding: EdgeInsets.only(bottom: 8), child: Divider()),
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          widget._note == null
              ? "Unsaved"
              : 'Last edited ${widget._note.createdDate}',
          textAlign: TextAlign.end,
        ),
      )
    ]));
  }

// TODO Onchange we callback with the change
}
