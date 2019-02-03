import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notable/model/note.dart';

@immutable
class NoteItemWidget extends StatelessWidget {
  final Note note;
  final Function onTap;

  NoteItemWidget(this.note, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
      child: Column(children: <Widget>[
        Text(note.title),
        Text(note.content),
        Text(note.labels.toString()),
        Text(note.createdDate.toIso8601String())
      ]),
      onTap: onTap,
    ));
  }
}
