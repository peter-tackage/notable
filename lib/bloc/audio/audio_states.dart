import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/audio_note.dart';
import 'package:notable/model/audio_playback.dart';
import 'package:notable/model/audio_recording.dart';

@immutable
abstract class AudioNoteState extends Equatable {
  AudioNoteState([List props = const []]) : super(props);
}

@immutable
class AudioNoteLoading extends AudioNoteState {
  @override
  String toString() => 'AudioNoteLoading';
}

// The idea here is for BaseAudioNoteLoaded to be a bit like a sealed class.
@immutable
abstract class BaseAudioNoteLoaded extends AudioNoteState {
  final AudioNote audioNote;

  BaseAudioNoteLoaded(this.audioNote, [List props = const []])
      : super([audioNote, ...props]); // ignore: sdk_version_ui_as_code
}

@immutable
class AudioNoteLoaded extends BaseAudioNoteLoaded {
  AudioNoteLoaded(audioNote) : super(audioNote);

  @override
  String toString() => 'AudioNoteLoaded { notes: $audioNote }';
}

@immutable
class AudioNotePlayback extends BaseAudioNoteLoaded {
  final AudioPlayback audioPlayback;

  AudioNotePlayback(audioNote, this.audioPlayback)
      : super(audioNote, [audioPlayback]);

  @override
  String toString() {
    return 'AudioNotePlayback: { audioPlayback : ${audioPlayback.playbackState} }';
  }
}

@immutable
class AudioNoteRecording extends BaseAudioNoteLoaded {
  final AudioRecording audioRecording;

  AudioNoteRecording(
    audioNote,
    this.audioRecording,
  ) : super(audioNote, [audioRecording]);

  @override
  String toString() {
    return 'AudioNoteRecording: { audioRecording : ${audioRecording.recordingState} }';
  }
}
