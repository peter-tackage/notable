import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:notable/bloc/audio/audio.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/entity/audio_note_entity.dart';
import 'package:notable/l10n/localization.dart';
import 'package:notable/model/audio_note.dart';
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

  AudioNoteBloc _audioNoteBlocBuilder(context) => AudioNoteBloc(
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
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final String id;

  _AddEditAudioNoteScreenContent({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AudioNoteBloc audioNoteBloc = BlocProvider.of<AudioNoteBloc>(context);

    return BlocBuilder<AudioNoteBloc, AudioNoteState>(
        builder: (BuildContext context, AudioNoteState state) {
      // FIXME - Feels like this interpretation should be part of the state, perhaps?
      final isNoteSaveable =
          state is AudioNoteLoaded && state.audioNote.filename != null ||
              state is AudioNotePlayback && state.audioNote.filename != null;

      return Scaffold(
          appBar: AppBar(
              title: Text(NotableLocalizations.of(context).audio_note_title),
              actions: _defineMenuItems(context, audioNoteBloc)),
          body: _buildBody(context, audioNoteBloc, state),
          floatingActionButton: isNoteSaveable
              ? FloatingActionButton(
                  onPressed: () => _saveNote(context, audioNoteBloc),
                  tooltip: NotableLocalizations.of(context).note_save_tooltip,
                  child: Icon(Icons.check),
                )
              : null);
    });
  }

  Widget _buildBody(context, audioNoteBloc, state) {
    if (state is BaseAudioNoteLoaded) {
      return Padding(
          padding: EdgeInsets.only(top: 8, left: 8, right: 8),
          child: Form(
              key: _formKey,
              child: Column(children: <Widget>[
                TextFormField(
                    enabled: state is AudioNoteLoaded,
                    onSaved: (newTitle) =>
                        _onSaveTitle(newTitle, audioNoteBloc),
                    initialValue: state.audioNote.title,
                    style: Theme.of(context).textTheme.title,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText:
                            NotableLocalizations.of(context).note_title_hint),
                    maxLines: 1),
                AudioNotePage()
              ])));
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

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
                        child: Text(NotableLocalizations.of(context)
                            .note_delete_menu_item),
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

    // Create or update handled in bloc.
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
  // Title save
  //

  _onSaveTitle(newTitle, audioNoteBloc) {
    audioNoteBloc.dispatch(UpdateAudioNoteTitle(newTitle));
  }
}
