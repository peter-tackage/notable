import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notable/model/text_note.dart';

class NoteItemWidget extends StatelessWidget {
  final TextNote note;
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
                note.title.isNotEmpty ? Text(note.title) : SizedBox.shrink(),
                note.title.isNotEmpty && note.text.isNotEmpty
                    ? Divider()
                    : SizedBox.shrink(),
                note.text.isNotEmpty ? Text(note.text) : SizedBox.shrink()
              ])),
      onTap: onTap,
    ));
  }
}
