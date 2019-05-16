import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notable/model/note.dart';

class NoteAddEditPage extends StatelessWidget {
  final Note _note;
  final FormFieldSetter<String> onSaveTitleCallback;
  final FormFieldSetter<String> onSaveContentCallback;

  NoteAddEditPage(this._note,
      {@required this.onSaveTitleCallback,
      @required this.onSaveContentCallback});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: TextFormField(
              onSaved: onSaveTitleCallback,
              initialValue: _note?.title ?? '',
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Task...'),
              maxLines: 1,
              autofocus: true)),
      Expanded(
          child: Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: TextFormField(
                  onSaved: onSaveContentCallback,
                  initialValue: _note?.text ?? '',
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Enter your note...'),
                  maxLines: null,
                  keyboardType: TextInputType.multiline))),
      Divider(),
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        Text(_note == null ? "Unsaved" : 'Created: ${_note.updatedDate}')
      ]),
    ]);
  }
}
