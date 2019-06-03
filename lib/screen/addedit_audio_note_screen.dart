import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notable/bloc/audio/audio.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/entity/audio_note_entity.dart';
import 'package:notable/model/audio_note.dart';
import 'package:notable/widget/audio_note_page.dart';

class AddEditAudioNoteScreen extends StatefulWidget {
  final String id;

  AddEditAudioNoteScreen({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddEditAudioNoteScreenState();
}

class _AddEditAudioNoteScreenState extends State<AddEditAudioNoteScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AudioNoteBloc _audioNoteBloc;

  @override
  void initState() {
    super.initState();
    _audioNoteBloc = AudioNoteBloc(
        notesBloc:
            BlocProvider.of<NotesBloc<AudioNote, AudioNoteEntity>>(context),
        id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Audio"), actions: _defineMenuItems()),
        body: Padding(
            padding: EdgeInsets.only(top: 8, left: 8, right: 8),
            child: BlocProvider(bloc: _audioNoteBloc, child: AudioNotePage())),
        floatingActionButton: FloatingActionButton(
          onPressed: _saveNote,
          tooltip: 'Save audio note',
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
  // Save
  //

  _saveNote() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }

    // Create or update handled elsewhere.
    _audioNoteBloc.dispatch(SaveAudioNote());

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
      _audioNoteBloc.dispatch(DeleteAudioNote());
      Navigator.pop(context);
    }
  }

  _titleChanged(String newTitle) {
    // TODO Implement this
    //  _audioNoteBloc.dispatch(UpdateAudioNoteTitle(newTitle));
  }

  Widget _buildAudioNote(BuildContext context, AudioNote audioNote) {
    return AudioNotePage();
  }
}
