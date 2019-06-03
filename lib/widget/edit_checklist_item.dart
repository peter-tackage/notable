import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notable/model/checklist.dart';

class EditChecklistItem extends StatefulWidget {
  final ChecklistItem initialValue;
  final Function(bool isDone, String task) onSaved;
  final Function(ChecklistItem item) onSubmit;
  final bool isFocused;

  EditChecklistItem(
      {@required this.initialValue,
      @required this.onSaved,
      @required this.onSubmit,
      @required this.isFocused});

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
//               textInputAction: state.value.isEmpty()
//                   ? TextInputAction.next
//                  : TextInputAction.done,
            textCapitalization: TextCapitalization.sentences,
            initialValue: widget.initialValue.task,
            onSaved: (text) => widget.onSaved(_isDone, text),
            onFieldSubmitted: (text) => widget.onSubmit(
                widget.initialValue.copyWith(task: text, isDone: _isDone)),
            maxLines: 1,
            enabled: !_isDone,

            style: TextStyle(
                color: _isDone ? Colors.grey : Colors.black,
                decoration:
                    _isDone ? TextDecoration.lineThrough : TextDecoration.none),
            autofocus: widget.isFocused,
            decoration:
                InputDecoration(border: InputBorder.none, hintText: 'Task...'),
          )),
        ]));
  }
}

// FIXME Still want to prevent the cursor from disappearing when submitting last
