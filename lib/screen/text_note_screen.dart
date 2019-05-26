import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/entity/entity.dart';
import 'package:notable/model/label.dart';
import 'package:notable/model/text_note.dart';

class AddEditTextNoteScreen extends StatefulWidget {
  final String id;

  AddEditTextNoteScreen({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddEditTextNoteScreenState();
}

class _AddEditTextNoteScreenState extends State<AddEditTextNoteScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  NotesBloc _notesBloc;

  TextNote _note;
  String _updatedTitle;
  String _updatedText;

  @override
  void initState() {
    super.initState();
    _notesBloc = BlocProvider.of<NotesBloc<TextNote, NoteEntity>>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Note"), actions: <Widget>[
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
                bloc: _notesBloc,
                builder: (BuildContext context, NotesState state) {
                  if (state is NotesLoaded) {
                    _note = state.notes.firstWhere(
                        (note) => note.id == widget.id,
                        orElse: () => TextNote('', List<Label>(), ''));

                    return Form(
                        key: _formKey,
                        child: Column(children: <Widget>[
                          TextFormField(
                              onSaved: _titleChanged,
                              initialValue: _updatedTitle ?? _note.title,
                              style: Theme.of(context).textTheme.title,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Title...'),
                              maxLines: 1,
                              autofocus: true),
                          Expanded(
                              child: Padding(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  child: TextFormField(
                                      onSaved: _textContentChanged,
                                      initialValue: _updatedText ?? _note.text,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Enter your note...'),
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline))),
                          Divider(height: 0),
                          Container(
                              padding:
                                  EdgeInsets.only(left: 4, top: 12, bottom: 12),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      _note.updatedDate == null
                                          ? "Unsaved"
                                          : "Saved " +
                                              DateFormat("HH:mm dd/MM/yyyy")
                                                  .format(_note.updatedDate),
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
          tooltip: 'Save note',
          child: Icon(Icons.check),
        ));
  }

  //
  // Update
  //

  void _titleChanged(String newValue) => _updatedTitle = newValue;

  void _textContentChanged(String newValue) => _updatedText = newValue;

  //
  // Save
  //

  _saveNote() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }

    // Create or update
    if (widget.id == null) {
      _notesBloc.dispatch(
          AddNote(TextNote(_updatedTitle, List<Label>(), _updatedText)));
    } else {
      _notesBloc
          .dispatch(UpdateNote(_note.copyWith(_updatedTitle, _updatedText)));
    }

    Navigator.pop(context);
  }

  //
  // Delete
  //

  void _handleMenuItemSelection(value) {
    if (value == "delete") {
      _deleteNote();
    }
  }

  void _deleteNote() {
    if (widget.id != null) {
      _notesBloc.dispatch(DeleteNote(widget.id));
      Navigator.pop(context);
    }
  }
}
