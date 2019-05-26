import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notable/bloc/checklist/checklist.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/entity/entity.dart';
import 'package:notable/model/checklist.dart';
import 'package:notable/widget/checklist_item.dart';

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
        appBar: AppBar(
            title: Text("Checklist"),
            actions: widget.id == null
                ? null
                : <Widget>[
                    PopupMenuButton(
                        onSelected: _handleMenuItemSelection,
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                value: "delete",
                                child: Text("Delete"),
                              )
                            ])
                  ]),
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
                              onSaved: _titleChanged,
                              initialValue: state.checklist.title,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Title...'),
                              maxLines: 1,
                              autofocus: true),
                          Expanded(
                              child: _buildChecklist(context, state.checklist)),
                          Divider(),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(state.checklist.id == null
                                    ? "Unsaved"
                                    : 'Edited: ${state.checklist.updatedDate}')
                              ]),
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

  //
  // Checklist builder
  //

  Widget _buildChecklist(BuildContext context, Checklist checklist) =>
      ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            int lastIndex = checklist.items.length - 1;
            bool isLastItem = index == lastIndex;
            bool isFocused = isLastItem && checklist.items.length > 1;

            return Container(
                child: ChecklistItemWidget(
                    onSaved: (isDone, task) =>
                        _setItem(index, ChecklistItem(task, isDone)),
                    initialValue: checklist.items[index],
                    //  isFocused: isFocused,
                    onSubmit: (item) =>
                        _handleSubmitItem(item, index, isLastItem)));
          },
          itemCount: checklist.items.length);

  // TODO Also must not allow submit when the item is empty, because even the act of submitting causes the focus to be lost.

  void _handleSubmitItem(ChecklistItem item, int index, bool isLastItem) {
    // Update the Bloc state with the submitted item
    _checklistBloc.dispatch(SetChecklistItem(index, item));

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
    print("_handleMenuItemSelection");
    if (value == "delete") {
      _deleteNote();
    }
  }

  _deleteNote() {
    print("_deleteNote: ${widget.id}");

    if (widget.id != null) {
      _checklistBloc.dispatch(DeleteChecklist());
      Navigator.pop(context);
    }
  }

  _titleChanged(String newTitle) {
    _checklistBloc.dispatch(UpdateChecklistTitle(newTitle));
  }

  _setItem(int index, ChecklistItem item) {
    _checklistBloc.dispatch(SetChecklistItem(index, item));
  }
}
