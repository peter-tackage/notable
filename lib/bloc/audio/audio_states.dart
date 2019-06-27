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

@immutable
class AudioNoteLoaded extends AudioNoteState {
  final AudioNote audioNote;

  AudioNoteLoaded(this.audioNote) : super([audioNote]);

  @override
  String toString() => 'AudioNoteLoaded { notes: $audioNote }';
}

@immutable
class AudioNotePlayback extends AudioNoteState {
  final AudioNote audioNote;
  final AudioPlayback audioPlayback;

  AudioNotePlayback(this.audioNote, this.audioPlayback)
      : super([audioNote, audioPlayback]);

  @override
  String toString() {
    return 'AudioNotePlayback: { audioPlayback : ${audioPlayback.playbackState}';
  }
}

@immutable
class AudioNoteRecording extends AudioNoteState {
  final AudioNote audioNote;
  final AudioRecording audioRecording;

  AudioNoteRecording(
    this.audioNote,
    this.audioRecording,
  ) : super([audioNote, audioRecording]);

  @override
  String toString() {
    return 'AudioNoteRecording: { audioRecording : ${audioRecording.recordingState}';
  }
}
