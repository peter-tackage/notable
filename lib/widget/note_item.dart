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
      child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                note.task.isNotEmpty ? Text(note.task) : SizedBox.shrink(),
                note.task.isNotEmpty && note.content.isNotEmpty
                    ? Divider()
                    : SizedBox.shrink(),
                note.content.isNotEmpty ? Text(note.content) : SizedBox.shrink()
              ])),
      onTap: onTap,
    ));
  }
}
