import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notable/model/checklist.dart';

class ChecklistItemWidget extends FormField<ChecklistItem> {
  // TODO Editing complete or field submitted
  ChecklistItemWidget(
      {FormFieldSetter<ChecklistItem> onSaved,
      ChecklistItem initialValue,
      bool isFocused,
      Function(String task) onSubmit})
      : super(
            onSaved: onSaved,
            initialValue: initialValue,
            autovalidate: false,
            builder: (FormFieldState<ChecklistItem> state) =>
                _createFormBuilder(state, isFocused, onSubmit));

  static Widget _createFormBuilder(FormFieldState<ChecklistItem> state,
      bool isFocused, Function(String task) onSubmit) {
    print("Drawing item: ${state.value}");

    // FIXME Problem with editing existing values, cursor position.
    return Padding(
        padding: EdgeInsets.all(0),
        child: Row(children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Checkbox(
                  value: state.value.isDone,
                  onChanged: (isDone) => _commitIsDoneChange(state, isDone))),
          Expanded(
              child: TextField(
            onChanged: (text) => _commitTaskValue(state, text),
            controller: TextEditingController(text: state.value.task),
            onSubmitted: onSubmit,
            autofocus: isFocused,
            maxLines: 1,
            decoration:
                InputDecoration(border: InputBorder.none, hintText: 'Task...'),
          )),
        ]));
  }

  static void _commitIsDoneChange(
          FormFieldState<ChecklistItem> state, bool isDone) =>
      state.didChange(state.value.copyWith(isDone: isDone));

  static void _commitTaskValue(
      FormFieldState<ChecklistItem> state, String task) {
    print("Commiting item value: $task");
    state.didChange(state.value.copyWith(task: task));
  }
}