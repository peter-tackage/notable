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
          if (state is AudioNoteLoaded ||
              state is AudioNotePlayback ||
              state is AudioNoteRecording) {
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
    print(state);

    bool isRecordingButtonEnabled = state is AudioNotePlayback == false;

    bool isPlaybackButtonEnabled =
        state is AudioNoteLoaded && state.audioNote.length > 0 ||
            state is AudioNoteLoaded && state.audioNote.id != null;

    bool isRewindButtonEnabled =
        state is AudioNoteLoaded && state.audioNote.length > 0 ||
            state is AudioNotePlayback;

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
      Row(children: <Widget>[
        RaisedButton(
          onPressed:
              isRecordingButtonEnabled ? () => _recordAction(state) : null,
          shape: CircleBorder(),
          color: Colors.white,
          disabledColor: Colors.grey[300],
          elevation: 4.0,
          child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  border: Border.all(
                      color:
                          isRecordingButtonEnabled ? Colors.green : Colors.grey,
                      width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              child: Icon(
                _recordIconOf(state),
                color: isRecordingButtonEnabled ? Colors.green : Colors.grey,
                size: 38.0,
              )),
        ),
        RaisedButton(
          onPressed:
              isPlaybackButtonEnabled ? () => _playbackAction(state) : null,
          shape: CircleBorder(),
          color: Colors.white,
          disabledColor: Colors.grey[300],
          elevation: 4.0,
          child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  border: Border.all(
                      color:
                          isPlaybackButtonEnabled ? Colors.green : Colors.grey,
                      width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              child: Icon(
                _playbackIconOf(state),
                color: isPlaybackButtonEnabled ? Colors.green : Colors.grey,
                size: 38.0,
              )),
        ),
        RaisedButton(
          onPressed: isPlaybackButtonEnabled ? _rewindAction : null,
          shape: CircleBorder(),
          color: Colors.white,
          disabledColor: Colors.grey[300],
          elevation: 4.0,
          child: Container(
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: isRewindButtonEnabled ? Colors.green : Colors.grey,
                      width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              child: Icon(
                Icons.fast_rewind,
                color: isRewindButtonEnabled ? Colors.green : Colors.grey,
                size: 24.0,
              )),
        )
      ])
    ]));
  }

  static String toDuration(AudioNoteRecording state) {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(
        state.audioRecording.progress.toInt(),
        isUtc: true);
    return DateFormat('mm:ss', 'en_GB').format(date);
  }

  IconData _recordIconOf(AudioNoteState state) {
    if (state is AudioNoteRecording &&
        state.audioRecording.recordingState == RecordingState.Recording) {
      return Icons.stop;
    } else {
      return Icons.mic;
    }
  }

  IconData _playbackIconOf(AudioNoteState state) {
    if (state is AudioNotePlayback &&
        state.audioPlayback.playbackState == PlaybackState.Playing) {
      return Icons.pause;
    } else {
      return Icons.play_arrow;
    }
  }

  _rewindAction() => _audioNoteBloc.dispatch(StopAudioPlaybackRequest());

  // TODO Could these be changed to toggle commands instead?

  void _recordAction(AudioNoteState state) {
    if (state is AudioNoteRecording &&
        state.audioRecording.recordingState == RecordingState.Recording) {
      _audioNoteBloc.dispatch(StopAudioRecordingRequest());
    } else {
      _audioNoteBloc.dispatch(StartAudioRecordingRequest());
    }
  }

  void _playbackAction(AudioNoteState state) {
    if (state is AudioNotePlayback &&
        state.audioPlayback.playbackState == PlaybackState.Playing) {
      _audioNoteBloc.dispatch(PauseAudioPlaybackRequest());
    } else {
      _audioNoteBloc.dispatch(StartAudioPlaybackRequest());
    }
  }
}
