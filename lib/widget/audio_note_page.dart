import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:notable/bloc/audio/audio.dart';
import 'package:notable/model/audio_note.dart';

class AudioNotePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AudioNotePageState();
}

class _AudioNotePageState extends State<AudioNotePage> {
  AudioNoteBloc _audioNoteBloc;

  bool _isRecording = false;
  bool _isPlaying = false;
  StreamSubscription _recorderSubscription;
  StreamSubscription _dbPeakSubscription;
  StreamSubscription _playerSubscription;
  FlutterSound flutterSound;

  @override
  void initState() {
    super.initState();
    _audioNoteBloc = BlocProvider.of<AudioNoteBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _audioNoteBloc,
        builder: (BuildContext context, AudioNoteState state) {
          if (state is AudioNoteLoaded) {
            return Column(children: <Widget>[
//                          TextFormField(
//                              onSaved: _titleChanged,
//                              initialValue: state.audioNote.title,
//                              style: Theme.of(context).textTheme.title,
//                              decoration: InputDecoration(
//                                  border: InputBorder.none,
//                                  hintText: 'Title...'),
//                              maxLines: 1,
//                              autofocus: false),
              Expanded(child: _buildAudioNote(context, state.audioNote)),
              Divider(height: 0),
            ]);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  void _play() {}

  _buildAudioNote(BuildContext context, AudioNote audioNote) {
    return Center(
        child: Column(children: <Widget>[
      Text("00:05 / 00:54", style: Theme.of(context).textTheme.display1),
      RawMaterialButton(
        onPressed: () {},
        child: new Icon(
          Icons.play_arrow,
          color: Colors.white,
          size: 35.0,
        ),
        shape: new CircleBorder(),
        elevation: 2.0,
        fillColor: Colors.blue,
        padding: const EdgeInsets.all(30.0),
      ),
    ]));
  }
}
