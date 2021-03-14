import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notable/model/base_note.dart';

class NoteCard extends StatelessWidget {
  final BaseNote note;
  final Widget child;
  final Function onTap;

  NoteCard({@required this.note, @required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    var isUntitled = note.title == null || note.title.isEmpty;
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 4,
        child: InkWell(
          onTap: onTap,
          child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        isUntitled
                            ? AppLocalizations.of(context)
                                .note_untitled_placeholder
                            : note.title,
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            color: isUntitled ? Colors.grey : Colors.black)),
                    Divider(),
                    ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 250),
                        child: child)
                  ])),
        ));
  }
}
