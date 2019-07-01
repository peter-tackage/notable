import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:notable/bloc/audio/audio.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/entity/audio_note_entity.dart';
import 'package:notable/model/audio_note.dart';
import 'package:notable/storage/sound_storage.dart';
import 'package:notable/widget/audio_note_page.dart';
import 'package:path_provider/path_provider.dart';

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
        id: widget.id,
        flutterSound: FlutterSound()
          ..setDbLevelEnabled(true)
          ..setDbPeakLevelUpdate(0.1),
        soundStorage: SoundStorage(
            getDirectory: () => getApplicationDocumentsDirectory(),
            filenameGenerator: soundFilenameGenerator));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Audio"), actions: _defineMenuItems()),
        body: BlocProvider<AudioNoteBloc>(
            bloc: _audioNoteBloc, child: _buildBody()),
        floatingActionButton: FloatingActionButton(
          onPressed: _saveNote,
          tooltip: 'Save audio note',
          child: Icon(Icons.check),
        ));
  }

  Widget _buildBody() {
    return BlocBuilder(
        bloc: _audioNoteBloc,
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
                          onSaved: _titleChanged,
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

  //
  // Title change
  //

  _titleChanged(String newTitle) {
    _audioNoteBloc.dispatch(UpdateAudioNoteTitle(newTitle));
  }
}
