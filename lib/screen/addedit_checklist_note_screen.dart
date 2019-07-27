import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notable/bloc/checklist/checklist.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/entity/entity.dart';
import 'package:notable/l10n/localization.dart';
import 'package:notable/model/checklist.dart';
import 'package:notable/widget/edit_checklist_item.dart';

class AddEditChecklistNoteScreen extends StatelessWidget {
  final String id;

  AddEditChecklistNoteScreen({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChecklistBloc>(
        builder: (BuildContext context) => ChecklistBloc(
            notesBloc:
                BlocProvider.of<NotesBloc<Checklist, ChecklistEntity>>(context),
            id: id),
        child: _AddEditChecklistNoteScreenContent(id: id));
  }
}

class _AddEditChecklistNoteScreenContent extends StatelessWidget {
  final String id;

  _AddEditChecklistNoteScreenContent({Key key, this.id}) : super(key: key);

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(NotableLocalizations.of(context).checklist_note_title),
            actions: _defineMenuItems(context)),
        body: Padding(
            padding: EdgeInsets.only(top: 8, left: 8, right: 8),
            child: BlocBuilder<ChecklistBloc, ChecklistState>(
                builder: (BuildContext context, ChecklistState state) {
              if (state is ChecklistLoaded) {
                return Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      TextFormField(
                          onSaved: (newTitle) =>
                              _onSaveTitle(newTitle, _checklistBlocOf(context)),
                          initialValue: state.checklist.title,
                          style: Theme.of(context).textTheme.title,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: NotableLocalizations.of(context)
                                  .note_title_hint),
                          maxLines: 1,
                          textCapitalization: TextCapitalization.sentences,
                          autofocus: false),
                      Expanded(
                          child: _buildChecklist(context, state.checklist)),
                    ]));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            })),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _saveNote(context),
          tooltip: NotableLocalizations.of(context).note_save_tooltip,
          child: Icon(Icons.check),
        ));
  }

  List<Widget> _defineMenuItems(context) {
    return id == null
        ? null
        : <Widget>[
            PopupMenuButton(
                onSelected: (menuItem) =>
                    _handleMenuItemSelection(menuItem, context),
                itemBuilder: (context) => [
                      PopupMenuItem(
                        value: "delete",
                        child: Text(NotableLocalizations.of(context)
                            .note_delete_menu_item),
                      )
                    ]),
          ];
  }

  ChecklistBloc _checklistBlocOf(context) =>
      BlocProvider.of<ChecklistBloc>(context);

  //
  // Checklist builder
  //

  Widget _buildChecklist(context, checklist) => ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        ChecklistItem item = checklist.items[index];
        int lastIndex = checklist.items.length - 1;
        bool isLastItem = index == lastIndex;
        bool isFocused = isLastItem && item.task.isEmpty;
        return Column(
            key: Key(item.id),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              EditChecklistItem(
                  onSaved: (isDone, task) => _setItem(
                      index,
                      item.rebuild((b) => b
                        ..task = task
                        ..isDone = isDone),
                      _checklistBlocOf(context)),
                  onCommit: (isDone, task) => _handleSubmitItem(
                      context,
                      item.rebuild((b) => b
                        ..task = task
                        ..isDone = isDone),
                      index,
                      isLastItem),
                  initialValue: item,
                  isFocused: isFocused),
              isLastItem
                  ? FlatButton.icon(
                      icon: Icon(Icons.add, color: Colors.grey),
                      label: Text(
                          NotableLocalizations.of(context)
                              .checklist_add_item_label,
                          style: TextStyle(color: Colors.grey)),
                      onPressed: () => _checklistBlocOf(context)
                          .dispatch(AddEmptyChecklistItem()))
                  : SizedBox.shrink()
            ]);
      },
      itemCount: checklist.items.length);

  // TODO Also must not allow submit when the item is empty, because even the act of submitting causes the focus to be lost.

  void _handleSubmitItem(
      BuildContext context, ChecklistItem item, int index, bool isLastItem) {
    // Update the Bloc state with the submitted item
    _setItem(index, item, _checklistBlocOf(context));

    if (isLastItem && item.task.isNotEmpty) {
      _checklistBlocOf(context).dispatch(AddEmptyChecklistItem());
    } else {
      // TODO Focus next
    }
  }

  //
  // Save
  //

  _saveNote(context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }

    // Create or update handled elsewhere.
    _checklistBlocOf(context).dispatch(SaveChecklist());

    Navigator.pop(context);
  }

  //
  // Delete
  //

  _handleMenuItemSelection(menuItem, context) {
    if (menuItem == "delete") {
      _deleteNote(context);
    }
  }

  _deleteNote(context) {
    if (id != null) {
      _checklistBlocOf(context).dispatch(DeleteChecklist());
      Navigator.pop(context);
    }
  }

  _onSaveTitle(newTitle, checklistBloc) {
    checklistBloc.dispatch(UpdateChecklistTitle(newTitle));
  }

  _setItem(int index, ChecklistItem item, checklistBloc) {
    checklistBloc.dispatch(SetChecklistItem(index, item));
  }
}
