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

  AudioNoteLoaded(this.audioNote, [List props = const []])
      : super([audioNote, ...props]);

  @override
  String toString() => 'AudioNoteLoaded { notes: $audioNote }';
}

@immutable
class AudioNotePlayback extends AudioNoteLoaded {
  final AudioPlayback audioPlayback;

  AudioNotePlayback(AudioNote audioNote, this.audioPlayback)
      : super(audioNote, [audioNote, audioPlayback]);

  @override
  String toString() {
    return 'AudioNotePlayback: { audioPlayback : ${audioPlayback.playbackState}';
  }
}

@immutable
class AudioNoteRecord extends AudioNoteLoaded {
  final AudioRecording audioRecording;

  AudioNoteRecord(
    AudioNote audioNote,
    this.audioRecording,
  ) : super(audioNote, [audioNote, audioRecording]);

  @override
  String toString() {
    return 'AudioNoteRecord: { audioRecord : ${audioRecording.recordingState}';
  }
}
