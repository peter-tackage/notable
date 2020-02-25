import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notable/model/audio_note.dart';

import 'note_card.dart';

class AudioNoteCardItem extends StatelessWidget {
  final AudioNote audioNote;
  final Function onTap;

  AudioNoteCardItem({@required this.audioNote, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return NoteCard(
      note: audioNote,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox.shrink(),
      ),
      onTap: onTap,
    );
  }
}
