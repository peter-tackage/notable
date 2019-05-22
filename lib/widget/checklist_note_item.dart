import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notable/model/checklist.dart';

class ChecklistNoteItem extends StatelessWidget {
  final Checklist checklist;
  final Function onTap;

  ChecklistNoteItem({this.checklist, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
      child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(checklist.title.isNotEmpty ? checklist.title : 'Untitled'),
                Column(
                    children: checklist.items.map(_createItemWidget).toList()),
                Divider(),
                Text(checklist.updatedDate.toIso8601String())
              ])),
      onTap: onTap,
    ));
  }

  Widget _createItemWidget(ChecklistItem item) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: <Widget>[
        Expanded(
            child: item.isDone
                ? Text(item.task,
                    style: TextStyle(decoration: TextDecoration.lineThrough))
                : Text(item.task))
      ]),
    );
  }
}
