import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/entity/entity.dart';
import 'package:notable/l10n/localization.dart';
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
        appBar: AppBar(
            title: Text(NotableLocalizations.of(context).text_note_title),
            actions: widget.id == null
                ? null
                : <Widget>[
                    PopupMenuButton(
                        onSelected: _handleMenuItemSelection,
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                value: "delete",
                                child: Text(NotableLocalizations.of(context)
                                    .note_delete_menu_item),
                              )
                            ])
                  ]),
        body: Padding(
            padding: EdgeInsets.only(top: 8, left: 8, right: 8),
            child: BlocBuilder(
                bloc: _notesBloc,
                builder: (BuildContext context, NotesState state) {
                  if (state is NotesLoaded) {
                    _note =
                        state.notes.firstWhere((note) => note.id == widget.id,
                            orElse: () => TextNote((b) => b
                              ..title = ''
                              ..labels = ListBuilder<Label>()
                              ..text = ''));

                    return Form(
                        key: _formKey,
                        child: Column(children: <Widget>[
                          TextFormField(
                              onSaved: _titleChanged,
                              initialValue: _updatedTitle ?? _note.title,
                              style: Theme.of(context).textTheme.title,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: NotableLocalizations.of(context)
                                      .note_title_hint),
                              maxLines: 1),
                          Expanded(
                              child: Padding(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  child: TextFormField(
                                      onSaved: _textContentChanged,
                                      initialValue: _updatedText ?? _note.text,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText:
                                              NotableLocalizations.of(context)
                                                  .text_note_hint),
                                      maxLines: null,
                                      autofocus: _note.text.isEmpty,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      keyboardType: TextInputType.multiline))),
                          Divider(height: 0),
                          Container(
                              padding:
                                  EdgeInsets.only(left: 4, top: 13, bottom: 13),
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
          tooltip: NotableLocalizations.of(context).note_save_tooltip,
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
      _notesBloc.dispatch(AddNote(TextNote((b) => b
        ..title = _updatedTitle
        ..labels = ListBuilder<Label>()
        ..text = _updatedText)));
    } else {
      _notesBloc.dispatch(UpdateNote(_note.rebuild((b) => b
        ..title = _updatedTitle
        ..text = _updatedText)));
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
