import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notable/model/checklist.dart';

class ChecklistItemWidget extends FormField<ChecklistItem> {
  // TODO Editing complete or field submitted
  ChecklistItemWidget(
      FormFieldSetter<ChecklistItem> onSaved,
      FormFieldValidator<ChecklistItem> validator,
      ChecklistItem initialValue,
      bool isFocused,
      Function(String task) onSubmit)
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidate: false,
            builder: (FormFieldState<ChecklistItem> state) =>
                _createBuilder(state, isFocused, onSubmit));

  static Widget _createBuilder(FormFieldState<ChecklistItem> state,
          bool isFocused, Function(String task) onSubmit) =>
      Padding(
          padding: EdgeInsets.all(0),
          child: Row(children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Checkbox(
                    value: state.value.isDone,
                    onChanged: (isDone) => _handleIsDoneChange(state, isDone))),
            Expanded(
                child: TextFormField(
              onEditingComplete: () =>
                  _handleTextChange(state, state.value.task),
              onFieldSubmitted: onSubmit,
              initialValue: state.value.task,
              //  controller: TextEditingController(text: state.value.task),
              autofocus: isFocused,
              maxLines: 1,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Task...'),
            )),
          ]));

  static void _handleIsDoneChange(
          FormFieldState<ChecklistItem> state, bool isDone) =>
      state.didChange(state.value.copyWith(isDone: isDone));

  static void _handleTextChange(
          FormFieldState<ChecklistItem> state, String task) =>
      state.didChange(state.value.copyWith(task: task));
}
