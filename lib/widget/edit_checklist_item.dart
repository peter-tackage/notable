import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notable/l10n/localization.dart';
import 'package:notable/model/checklist.dart';

class EditChecklistItem extends StatefulWidget {
  final ChecklistItem initialValue;
  final Function(bool isDone, String task) onSaved;
  final Function(bool isDone, String task) onCommit;
  final bool isFocused;

  EditChecklistItem(
      {@required this.initialValue,
      @required this.onSaved,
      @required this.onCommit,
      @required this.isFocused});

  @override
  State<StatefulWidget> createState() => _EditChecklistItemState();
}

class _EditChecklistItemState extends State<EditChecklistItem> {
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialValue.task);
  }

  @override
  Widget build(BuildContext context) {
    bool isDone = widget.initialValue.isDone;

    return Padding(
        padding: EdgeInsets.all(0),
        child: Row(children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Checkbox(
                  value: isDone,
                  onChanged: (newIsDone) =>
                      widget.onCommit(newIsDone, _textController.text))),
          Expanded(
              child: TextFormField(
            textCapitalization: TextCapitalization.sentences,
            controller: _textController,
            onEditingComplete: () =>
                widget.onCommit(isDone, _textController.text),
            onSaved: (text) => widget.onSaved(isDone, text),
            maxLines: 1,
            enabled: !isDone,
            style: TextStyle(
                color: isDone ? Colors.grey : Colors.black,
                decoration:
                    isDone ? TextDecoration.lineThrough : TextDecoration.none),
            autofocus: widget.isFocused,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: NotableLocalizations.of(context).checklist_item_hint),
          )),
        ]));
  }
}

// FIXME Still want to prevent the cursor from disappearing when submitting last
