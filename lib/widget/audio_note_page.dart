import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:notable/bloc/audio/audio.dart';
import 'package:notable/model/audio_playback.dart';
import 'package:notable/model/audio_recording.dart';
import 'package:notable/widget/audio_monitor.dart';

class AudioNotePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AudioNotePageState();
}

class _AudioNotePageState extends State<AudioNotePage> {
  AudioNoteBloc _audioNoteBloc;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
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
              Expanded(child: _buildAudioNote(context, state)),
              Divider(height: 0),
            ]);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  _buildAudioNote(BuildContext context, AudioNoteState state) {
    return Center(
        child: Column(children: <Widget>[
      Text(state is AudioNoteRecording ? toDuration(state) : "0",
          style: Theme.of(context).textTheme.display1),
      Text(
          state is AudioNoteRecording
              ? state.audioRecording.level.toString()
              : "-",
          style: Theme.of(context).textTheme.display1),
      AudioMonitor(
          peakDb: 160,
          level: state is AudioNoteRecording ? state.audioRecording.level : 0),
      RawMaterialButton(
        onPressed: () => _audioAction(state),
        child: new Icon(
          _icon(state),
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

  static String toDuration(AudioNoteRecording state) {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(
        state.audioRecording.progress.toInt(),
        isUtc: true);
    return DateFormat('mm:ss', 'en_GB').format(date);
  }

  IconData _icon(AudioNoteState state) {
    if (state is AudioNoteRecording) {
      switch (state.audioRecording.recordingState) {
        case RecordingState.Recording:
          return Icons.stop;
        case RecordingState.Recorded:
          return Icons.play_arrow;
        default:
          throw Exception(
              "Unsupported recording state: ${state.audioRecording.recordingState}");
      }
    } else if (state is AudioNotePlayback) {
      return state.audioPlayback.playbackState == PlaybackState.Playing
          ? Icons.stop
          : Icons.play_arrow;
    } else {
      return Icons.mic;
    }
  }

  void _audioAction(AudioNoteState state) {
    if (state is AudioNoteRecording) {
      if (state.audioRecording.recordingState == RecordingState.Recording) {
        _audioNoteBloc.dispatch(StopAudioRecordingRequest());
      } else {
        _audioNoteBloc.dispatch(StartAudioRecordingRequest());
      }
    } else if (state is AudioNotePlayback) {
      state.audioPlayback.playbackState == PlaybackState.Playing
          ? _audioNoteBloc.dispatch(StopAudioPlaybackRequest())
          : _audioNoteBloc.dispatch(StartAudioPlaybackRequest());
    } else if (state is AudioNoteLoaded) {
      _audioNoteBloc.dispatch(StartAudioRecordingRequest());
    }
  }
}