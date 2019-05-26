import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notable/model/base_note.dart';

class NoteCard extends StatelessWidget {
  final BaseNote note;
  final Function onTap;
  final Widget child;

  NoteCard({@required this.note, @required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
      child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                note.title.isNotEmpty
                    ? Text(note.title, style: Theme.of(context).textTheme.title)
                    : SizedBox.shrink(),
                Divider(),
                ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 250), child: child),
              ])),
      onTap: onTap,
    ));
  }
}
