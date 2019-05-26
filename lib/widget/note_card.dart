import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
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
                    ? Text(note.title,
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontSizeFactor: 1.5)
                            .apply(fontWeightDelta: 2))
                    : SizedBox.shrink(),
                Divider(),
                child,
                Divider(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        DateFormat("HH:mm dd/MM/yyyy").format(note.updatedDate),
                        style: TextStyle(color: Colors.grey),
                      )
                    ])
              ])),
      onTap: onTap,
    ));
  }
}
