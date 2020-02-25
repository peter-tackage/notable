import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notable/model/checklist.dart';

import 'note_card.dart';

class ChecklistNoteCardItem extends StatelessWidget {
  final Checklist checklist;
  final Function onTap;

  ChecklistNoteCardItem({this.checklist, this.onTap});

  @override
  Widget build(BuildContext context) {
    return NoteCard(
      note: checklist,
      child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: checklist.items.map(_createItemWidget).toList()),
      onTap: onTap,
    );
  }

  Widget _createItemWidget(ChecklistItem item) {
    return Row(children: <Widget>[
      Checkbox(
          value: item.isDone,
          activeColor: Colors.green[100],
          onChanged: (__) => onTap()), // don't actually toggle the state.
      Expanded(
          child: Text(item.task,
    style: TextStyle(
              color: item.isDone ? Colors.grey : Colors.black,
              decoration: item.isDone ? TextDecoration.lineThrough : TextDecoration.none)))
    ]);
  }
}
