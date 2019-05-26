import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notable/model/checklist.dart';

import 'note_card.dart';

class ChecklistNoteItem extends StatelessWidget {
  final Checklist checklist;
  final Function onTap;

  ChecklistNoteItem({this.checklist, this.onTap});

  @override
  Widget build(BuildContext context) {
    return NoteCard(
      note: checklist,
      child: Column(children: checklist.items.map(_createItemWidget).toList()),
      onTap: onTap,
    );
  }

  Widget _createItemWidget(ChecklistItem item) {
    return Row(children: <Widget>[
      Checkbox(
          value: item.isDone,
          activeColor: Colors.green[100],
          onChanged: _doNothing),
      Expanded(
          child: item.isDone
              ? Text(item.task,
                  style: TextStyle(decoration: TextDecoration.lineThrough))
              : Text(item.task))
    ]);
  }

  void _doNothing(bool value) {}
}
