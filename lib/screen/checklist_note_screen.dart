import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notable/bloc/checklist/checklist.dart';
import 'package:notable/bloc/notes/notes.dart';
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
        notesBloc: BlocProvider.of<NotesBloc>(context), id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    print("Building Checklist");

    return Scaffold(
        appBar: AppBar(title: Text("Checklist"), actions: <Widget>[
          PopupMenuButton(
              onSelected: (value) => _handleMenuItemSelection,
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
                  print("In WIDGET ChecklistState is $state");

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
                              autofocus: false),
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
                    return Text("State is: $state");
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
        itemBuilder: (BuildContext context, int index) => Container(
            child: ChecklistItemWidget(
                (item) => _addItem(index, item),
                doNoValidation,
                checklist.items[index],
                false,
                (__) => _moveToNextItem(index))),
        itemCount: checklist.items.length,
      );

  void _moveToNextItem(int index) {
    print("_moveToNextItem");
    _checklistBloc.dispatch(AddEmptyChecklistItem());
  }

  //
  // Save
  //

  _saveNote() {
    print("Saving checklist");
//    if (_formKey.currentState.validate()) {
//      // Let the form perform its own validation
//      _formKey.currentState.save();
//    }
//
//    print("Saving checklist: ${_checklist.items[0]}");
//
//    // Create or update
//    if (widget.id == null) {
//      _checklistBloc.dispatch(Add(
//          Checklist(_checklist.title, new List<Label>(), _checklist.items)));
//    } else {
//      //  _checklistBloc.dispatch(
//      //     UpdateNote(_checklist.copyWith(_updatedTitle, _updatedText)));
//    }
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
    print("Deleting: $widget.id");
    if (widget.id != null) {
      _checklistBloc.dispatch(DeleteChecklist());
      Navigator.pop(context);
    }
  }

  _titleChanged(String newValue) =>
      _checklistBloc.dispatch(UpdateChecklistTitle(newValue));

  _addItem(int index, ChecklistItem item) =>
      _checklistBloc.dispatch(AddChecklistItem(index, item));

  String doNoValidation(ChecklistItem value) {
    return null;
  }
}
