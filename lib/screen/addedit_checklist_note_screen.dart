import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notable/bloc/checklist/checklist.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/entity/entity.dart';
import 'package:notable/model/checklist.dart';
import 'package:notable/widget/edit_checklist_item.dart';

class AddEditChecklistNoteScreen extends StatefulWidget {
  final String id;

  AddEditChecklistNoteScreen({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddEditChecklistNoteScreenState();
}

class _AddEditChecklistNoteScreenState
    extends State<AddEditChecklistNoteScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ChecklistBloc _checklistBloc;

  @override
  void initState() {
    super.initState();
    _checklistBloc = ChecklistBloc(
        notesBloc:
            BlocProvider.of<NotesBloc<Checklist, ChecklistEntity>>(context),
        id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Checklist"), actions: _defineMenuItems()),
        body: Padding(
            padding: EdgeInsets.only(top: 8, left: 8, right: 8),
            child: BlocBuilder(
                bloc: _checklistBloc,
                builder: (BuildContext context, ChecklistState state) {
                  if (state is ChecklistLoaded) {
                    return Form(
                        key: _formKey,
                        child: Column(children: <Widget>[
                          TextFormField(
                              onSaved: _onSaveTitle,
                              initialValue: state.checklist.title,
                              style: Theme.of(context).textTheme.title,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Title...'),
                              maxLines: 1,
                              textCapitalization: TextCapitalization.sentences,
                              autofocus: false),
                          Expanded(
                              child: _buildChecklist(context, state.checklist)),
                          Divider(height: 0),
                          Container(
                              padding: EdgeInsets.only(left: 4, right: 4),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      state.checklist.updatedDate == null
                                          ? "Unsaved"
                                          : "Saved " +
                                              DateFormat("HH:mm dd/MM/yyyy")
                                                  .format(state
                                                      .checklist.updatedDate),
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontStyle: FontStyle.italic),
                                    )
                                  ]))
                        ]));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                })),
        floatingActionButton: FloatingActionButton(
          onPressed: _saveNote,
          tooltip: 'Save checklist',
          child: Icon(Icons.check),
        ));
  }

  List<Widget> _defineMenuItems() {
    return widget.id == null
        ? null
        : <Widget>[
            PopupMenuButton(
                onSelected: _handleMenuItemSelection,
                itemBuilder: (context) => [
                      PopupMenuItem(
                        value: "delete",
                        child: Text("Delete"),
                      )
                    ]),
          ];
  }

  //
  // Checklist builder
  //

  Widget _buildChecklist(BuildContext context, Checklist checklist) =>
      ListView.builder(
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
                            ..isDone = isDone)),
                      onCommit: (isDone, task) => _handleSubmitItem(
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
                          label: Text("Add item",
                              style: TextStyle(color: Colors.grey)),
                          onPressed: () =>
                              _checklistBloc.dispatch(AddEmptyChecklistItem()))
                      : SizedBox.shrink()
                ]);
          },
          itemCount: checklist.items.length);

  // TODO Also must not allow submit when the item is empty, because even the act of submitting causes the focus to be lost.

  void _handleSubmitItem(ChecklistItem item, int index, bool isLastItem) {
    // Update the Bloc state with the submitted item
    _setItem(index, item);

    if (isLastItem && item.task.isNotEmpty) {
      _checklistBloc.dispatch(AddEmptyChecklistItem());
    } else {
      // TODO Focus next
    }
  }

  //
  // Save
  //

  _saveNote() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }

    // Create or update handled elsewhere.
    _checklistBloc.dispatch(SaveChecklist());

    Navigator.pop(context);
  }

  //
  // Delete
  //

  _handleMenuItemSelection(value) {
    if (value == "delete") {
      _deleteNote();
    }
  }

  _deleteNote() {
    if (widget.id != null) {
      _checklistBloc.dispatch(DeleteChecklist());
      Navigator.pop(context);
    }
  }

  _onSaveTitle(String newTitle) {
    _checklistBloc.dispatch(UpdateChecklistTitle(newTitle));
  }

  _setItem(int index, ChecklistItem item) {
    _checklistBloc.dispatch(SetChecklistItem(index, item));
  }
}
