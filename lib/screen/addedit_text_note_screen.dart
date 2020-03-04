import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/bloc/text/text.dart';
import 'package:notable/entity/entity.dart';
import 'package:notable/l10n/localization.dart';
import 'package:notable/model/text_note.dart';

class AddEditTextNoteScreen extends StatelessWidget {
  final String id;

  AddEditTextNoteScreen({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TextNoteBloc>(
        builder: _textNoteBlocBuilder,
        child: _AddEditTextNoteScreenContent(id: id));
  }

  TextNoteBloc _textNoteBlocBuilder(context) => TextNoteBloc(
      notesBloc: BlocProvider.of<NotesBloc<TextNote, TextNoteEntity>>(context),
      id: id);
}

class _AddEditTextNoteScreenContent extends StatelessWidget {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static final _deleteItem = "delete";

  final String id;

  _AddEditTextNoteScreenContent({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextNoteBloc textNoteBloc = BlocProvider.of<TextNoteBloc>(context);

    return Scaffold(
        appBar: AppBar(
            title: Text(NotableLocalizations.of(context).text_note_title),
            actions: id == null
                ? null
                : <Widget>[
                    PopupMenuButton(
                        onSelected: (menuItem) => _handleMenuItemSelection(
                            menuItem, context, textNoteBloc),
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                value: _deleteItem,
                                child: Text(NotableLocalizations.of(context)
                                    .note_delete_menu_item),
                              )
                            ])
                  ]),
        body: Padding(
            padding: EdgeInsets.only(top: 8, left: 8, right: 8),
            child: BlocBuilder<TextNoteBloc, TextNoteState>(
                bloc: textNoteBloc,
                builder: (BuildContext context, TextNoteState state) {
                  if (state is TextNoteLoaded) {
                    TextNote note = state.textNote;

                    return Form(
                        key: _formKey,
                        child: Column(children: <Widget>[
                          TextFormField(
                              onSaved: (newTitle) =>
                                  _titleChanged(newTitle, textNoteBloc),
                              initialValue: note.title,
                              style: Theme.of(context).textTheme.title,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: NotableLocalizations.of(context)
                                      .note_title_hint),
                              maxLines: 1),
                          Expanded(
                                  child: TextFormField(
                                      onSaved: (newText) => _textContentChanged(
                                          newText, textNoteBloc),
                                      initialValue: note.text,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText:
                                              NotableLocalizations.of(context)
                                                  .text_note_hint),
                                      maxLines: null,
                                      autofocus: note.text.isEmpty,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      keyboardType: TextInputType.multiline)),
                        ]));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                })),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _saveNote(context, textNoteBloc),
          tooltip: NotableLocalizations.of(context).note_save_tooltip,
          child: Icon(Icons.check),
        ));
  }

  //
  // Update
  //

  void _titleChanged(newTitle, textNoteBloc) =>
      textNoteBloc.dispatch(UpdateTextNoteTitle(newTitle));

  void _textContentChanged(newText, textNoteBloc) =>
      textNoteBloc.dispatch(UpdateTextNoteText(newText));

  //
  // Save
  //

  _saveNote(context, textNoteBloc) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
    textNoteBloc.dispatch(SaveTextNote());
    Navigator.pop(context);
  }

  //
  // Delete
  //

  void _handleMenuItemSelection(menuItem, context, textNoteBloc) {
    if (menuItem == _deleteItem) {
      _deleteNote(context, textNoteBloc);
    }
  }

  void _deleteNote(context, textNoteBloc) {
    if (id != null) {
      textNoteBloc.dispatch(DeleteNote(id));
      Navigator.pop(context);
    }
  }
}
