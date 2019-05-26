import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notable/model/checklist.dart';

class EditChecklistItem extends StatefulWidget {
  final ChecklistItem initialValue;
  final Function(bool isDone, String task) onSaved;
  final Function(ChecklistItem item) onSubmit;

  EditChecklistItem({this.initialValue, this.onSaved, this.onSubmit});

  @override
  State<StatefulWidget> createState() =>
      _EditChecklistItemState(initialValue.isDone);
}

class _EditChecklistItemState extends State<EditChecklistItem> {
  bool _isDone;

  _EditChecklistItemState(this._isDone);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(0),
        child: Row(children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Checkbox(
                  value: _isDone,
                  onChanged: (isDone) => setState(() => _isDone = isDone))),
          Expanded(
              child: TextFormField(
            //   textInputAction: state.value.isEmpty()
            //       ? TextInputAction.next
            //      : TextInputAction.done,
            initialValue: widget.initialValue.task,
            onSaved: (text) => widget.onSaved(_isDone, text),
            onFieldSubmitted: (text) =>
                widget.onSubmit(ChecklistItem(text, _isDone)),
            maxLines: 1,
            decoration:
                InputDecoration(border: InputBorder.none, hintText: 'Task...'),
          )),
        ]));
  }
}

// FIXME Problem with editing existing values, cursor position.
// FIXME Still want to prevent the cursor from disappearing when submitting last
// TODO Perhap on submit could "commit" the value in the bloc and then add new row - NOT SAVING TO REPO, but a saving of the form
