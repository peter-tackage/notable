import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notable/model/text_note.dart';

import 'note_card.dart';

class NoteItemWidget extends StatelessWidget {
  final TextNote note;
  final Function onTap;

  NoteItemWidget(this.note, this.onTap);

  @override
  Widget build(BuildContext context) {
    return NoteCard(
      note: note,
      child: note.text.isNotEmpty
          ? Text(note.text, style: TextStyle(fontStyle: FontStyle.italic))
          : SizedBox.shrink(),
      onTap: onTap,
    );
  }
}
