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
          if (state is BaseAudioNoteLoaded) {
            return _buildAudioNote(context, state);
          } else {
            // FIXME Duplication again here - where should the BlocBuilder live?
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  _buildAudioNote(BuildContext context, AudioNoteState state) {
    bool isRecordingFeatureAvailable =
        state is BaseAudioNoteLoaded && state.audioNote.id == null;
    bool isRecordingButtonEnabled = state is AudioNotePlayback == false;

    bool isPlaybackButtonEnabled =
        state is AudioNoteLoaded && state.audioNote.filename != null ||
            state is AudioNotePlayback;

    bool isRewindButtonEnabled =
        state is AudioNoteLoaded && state.audioNote.filename != null ||
            state is AudioNotePlayback;

    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
            Widget>[
      Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Text(_timerTextOf(state),
              style: Theme.of(context).textTheme.display1)),
      isRecordingFeatureAvailable
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.mic,
                        color: state is AudioNoteRecording
                            ? Colors.green
                            : Colors.grey),
                    AudioMonitor(
                        peakDb: 160,
                        level: state is AudioNoteRecording
                            ? state.audioRecording.level
                            : 0)
                  ]))
          : SizedBox.shrink(),
      Padding(
          padding: EdgeInsets.symmetric(
              vertical: isRecordingFeatureAvailable ? 24 : 0),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
            isRecordingFeatureAvailable
                ? RaisedButton(
                    onPressed: isRecordingButtonEnabled
                        ? () => _recordAction(state)
                        : null,
                    shape: CircleBorder(),
                    color: Colors.white,
                    disabledColor: Colors.grey[300],
                    elevation: 4.0,
                    child: Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: isRecordingButtonEnabled
                                    ? Colors.green
                                    : Colors.grey,
                                width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        child: Icon(
                          _recordIconOf(state),
                          color: isRecordingButtonEnabled
                              ? Colors.green
                              : Colors.grey,
                          size: 38.0,
                        )),
                  )
                : SizedBox.shrink(),
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
                          color: isPlaybackButtonEnabled
                              ? Colors.green
                              : Colors.grey,
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
                          color: isRewindButtonEnabled
                              ? Colors.green
                              : Colors.grey,
                          width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  child: Icon(
                    Icons.fast_rewind,
                    color: isRewindButtonEnabled ? Colors.green : Colors.grey,
                    size: 24.0,
                  )),
            )
          ]))
    ]));
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
    } else if (state is AudioNotePlayback &&
        state.audioPlayback.playbackState == PlaybackState.Paused) {
      _audioNoteBloc.dispatch(ResumeAudioPlaybackRequest());
    } else {
      _audioNoteBloc.dispatch(StartAudioPlaybackRequest());
    }
  }

  String _timerTextOf(AudioNoteState state) {
    if (state is AudioNoteRecording) {
      return _toDuration(state.audioRecording.progress); // 00:04
    } else if (state is AudioNotePlayback) {
      // 00:01 / 00:04
      return "${_toDuration(state.audioPlayback.progress)} / ${_toDuration(state.audioNote.lengthMillis)}";
    } else if (state is AudioNoteLoaded) {
      return state.audioNote.filename == null
          ? "- / -"
          : "${_toDuration(0)} / ${_toDuration(state.audioNote.lengthMillis)}";
    } else {
      return "";
    }
  }

  static String _toDuration(double time) {
    DateTime date =
        DateTime.fromMillisecondsSinceEpoch(time.toInt(), isUtc: true);
    return DateFormat('mm:ss', 'en_GB').format(date);
  }
}
