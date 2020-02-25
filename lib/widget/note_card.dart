import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notable/l10n/localization.dart';
import 'package:notable/model/base_note.dart';

class NoteCard extends StatelessWidget {
  final BaseNote note;
  final Widget child;
  final Function onTap;

  NoteCard({@required this.note, @required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    bool isUntitled = note.title == null || note.title.isEmpty;
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 4,
        child: InkWell(
          child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        isUntitled
                            ? NotableLocalizations.of(context)
                                .note_untitled_placeholder
                            : note.title,
                        style: Theme.of(context).textTheme.title.copyWith(
                            color: isUntitled ? Colors.grey : Colors.black)),
                    Divider(),
                    ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 250),
                        child: child)
                  ])),
          onTap: onTap,
        ));
  }
}
