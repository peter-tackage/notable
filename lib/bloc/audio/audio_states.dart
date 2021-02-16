import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/audio_note.dart';
import 'package:notable/model/audio_playback.dart';
import 'package:notable/model/audio_recording.dart';

@immutable
abstract class AudioNoteState extends Equatable {
  const AudioNoteState();

  @override
  List<Object> get props => [];
}

@immutable
class AudioNoteLoading extends AudioNoteState {}

// The idea here is for BaseAudioNoteLoaded to be a bit like a sealed class.
@immutable
abstract class BaseAudioNoteLoaded extends AudioNoteState {
  final AudioNote audioNote;

  const BaseAudioNoteLoaded(this.audioNote);

  @override
  List<Object> get props => [audioNote];
}

@immutable
class AudioNoteLoaded extends BaseAudioNoteLoaded {
  const AudioNoteLoaded(audioNote) : super(audioNote);

  @override
  String toString() => 'AudioNoteLoaded { notes: $audioNote }';
}

@immutable
class AudioNotePlayback extends BaseAudioNoteLoaded {
  final AudioPlayback audioPlayback;

  const AudioNotePlayback(audioNote, this.audioPlayback) : super(audioNote);

  @override
  List<Object> get props => super.props + [audioPlayback];

  @override
  String toString() {
    return 'AudioNotePlayback: { audioPlayback : ${audioPlayback.playbackState} }';
  }
}

@immutable
class AudioNoteRecording extends BaseAudioNoteLoaded {
  final AudioRecording audioRecording;

  const AudioNoteRecording(
    audioNote,
    this.audioRecording,
  ) : super(audioNote);

  @override
  List<Object> get props => super.props + [audioRecording];

  @override
  String toString() {
    return 'AudioNoteRecording: { audioRecording : ${audioRecording.recordingState} }';
  }
}
