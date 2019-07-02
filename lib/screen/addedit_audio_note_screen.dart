import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:notable/bloc/audio/audio.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/entity/audio_note_entity.dart';
import 'package:notable/entity/base_note_entity.dart';
import 'package:notable/model/audio_note.dart';
import 'package:notable/model/base_note.dart';
import 'package:notable/storage/sound_storage.dart';
import 'package:notable/widget/audio_note_page.dart';
import 'package:path_provider/path_provider.dart';

class AddEditAudioNoteScreen extends StatelessWidget {
  final String id;

  AddEditAudioNoteScreen({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AudioNoteBloc>(
        builder: _audioNoteBlocBuilder,
        child: _AddEditAudioNoteScreenContent(id: id));
  }

  AudioNoteBloc<BaseNote, BaseNoteEntity> _audioNoteBlocBuilder(context) =>
      AudioNoteBloc(
          notesBloc:
              BlocProvider.of<NotesBloc<AudioNote, AudioNoteEntity>>(context),
          id: id,
          flutterSound: FlutterSound()
            ..setDbLevelEnabled(true)
            ..setDbPeakLevelUpdate(0.1),
          soundStorage: SoundStorage(
              getDirectory: () => getApplicationDocumentsDirectory(),
              filenameGenerator: soundFilenameGenerator));
}

class _AddEditAudioNoteScreenContent extends StatelessWidget {
  final String id;

  _AddEditAudioNoteScreenContent({Key key, this.id}) : super(key: key);

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AudioNoteBloc audioNoteBloc = BlocProvider.of<AudioNoteBloc>(context);

    return Scaffold(
        appBar: AppBar(
            title: Text("Audio"),
            actions: _defineMenuItems(context, audioNoteBloc)),
        body: _buildBody(context, audioNoteBloc),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _saveNote(context, audioNoteBloc),
          tooltip: 'Save audio note',
          child: Icon(Icons.check),
        ));
  }

  Widget _buildBody(context, audioNoteBloc) => BlocBuilder(
      bloc: audioNoteBloc,
      builder: (BuildContext context, AudioNoteState state) {
        print(state);
        if (state is BaseAudioNoteLoaded) {
          return Padding(
              padding: EdgeInsets.only(top: 8, left: 8, right: 8),
              child: Form(
                  key: _formKey,
                  child: Column(children: <Widget>[
                    TextFormField(
                        enabled: state is AudioNoteLoaded,
                        onSaved: (value) => _titleChanged(value, audioNoteBloc),
                        initialValue: state.audioNote.title,
                        style: Theme.of(context).textTheme.title,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: 'Title...'),
                        maxLines: 1),
                    AudioNotePage()
                  ])));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      });

  List<Widget> _defineMenuItems(context, audioNoteBloc) {
    return id == null
        ? null
        : <Widget>[
            PopupMenuButton(
                onSelected: (value) =>
                    _handleMenuItemSelection(value, context, audioNoteBloc),
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

  _saveNote(context, audioNoteBloc) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }

    // Create or update handled elsewhere.
    audioNoteBloc.dispatch(SaveAudioNote());

    Navigator.pop(context);
  }

  //
  // Delete
  //

  _handleMenuItemSelection(menuItem, context, audioNoteBloc) {
    if (menuItem == "delete") {
      _deleteNote(context, audioNoteBloc);
    }
  }

  _deleteNote(context, audioNoteBloc) {
    if (id != null) {
      audioNoteBloc.dispatch(DeleteAudioNote());
      Navigator.pop(context);
    }
  }

  //
  // Title change
  //

  _titleChanged(newTitle, audioNoteBloc) {
    audioNoteBloc.dispatch(UpdateAudioNoteTitle(newTitle));
  }
}
