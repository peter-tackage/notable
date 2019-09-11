import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/audio_note.dart';

@immutable
abstract class AudioNoteEvent extends Equatable {
  AudioNoteEvent([List props = const []]) : super(props);
}

@immutable
class LoadAudioNote extends AudioNoteEvent {
  final AudioNote audioNote;

  LoadAudioNote(this.audioNote) : super([audioNote]);

  @override
  String toString() => 'LoadAudioNote: {id: ${audioNote.id}';
}

@immutable
class SaveAudioNote extends AudioNoteEvent {
  SaveAudioNote() : super([]);

  @override
  String toString() => 'SaveAudioNote';
}

@immutable
class DeleteAudioNote extends AudioNoteEvent {
  DeleteAudioNote() : super([]);

  @override
  String toString() => 'DeleteAudioNote';
}

@immutable
class ClearAudioNote extends AudioNoteEvent {
  ClearAudioNote() : super([]);

  @override
  String toString() => 'ClearAudioNote';
}

@immutable
class UpdateAudioNoteTitle extends AudioNoteEvent {
  final String title;

  UpdateAudioNoteTitle(this.title) : super([title]);

  @override
  String toString() => 'UpdateAudioNoteTitle: $title';
}

@immutable
class StartAudioRecordingRequest extends AudioNoteEvent {
  StartAudioRecordingRequest() : super([]);

  @override
  String toString() => 'StartAudioRecordingRequest';
}

@immutable
class StopAudioRecordingRequest extends AudioNoteEvent {
  StopAudioRecordingRequest() : super([]);

  @override
  String toString() => 'StopAudioRecordingRequest';
}

@immutable
class StartAudioPlaybackRequest extends AudioNoteEvent {
  StartAudioPlaybackRequest() : super([]);

  @override
  String toString() => 'StartAudioPlaybackRequest';
}

@immutable
class PauseAudioPlaybackRequest extends AudioNoteEvent {
  PauseAudioPlaybackRequest() : super([]);

  @override
  String toString() => 'PauseAudioPlaybackRequest';
}

@immutable
class ResumeAudioPlaybackRequest extends AudioNoteEvent {
  ResumeAudioPlaybackRequest() : super([]);

  @override
  String toString() => 'ResumeAudioPlaybackRequest';
}

@immutable
class StopAudioPlaybackRequest extends AudioNoteEvent {
  StopAudioPlaybackRequest() : super([]);

  @override
  String toString() => 'StopAudioPlaybackRequest';
}

@immutable
class AudioRecordingProgressChanged extends AudioNoteEvent {
  final bool isRecording;
  final double progress;

  AudioRecordingProgressChanged(this.isRecording, this.progress)
      : super([isRecording, progress]);

  @override
  String toString() =>
      'AudioRecordingProgressChanged: { isRecording: $isRecording, progress: $progress}';
}

@immutable
class AudioRecordingLevelChanged extends AudioNoteEvent {
  final double level;

  AudioRecordingLevelChanged(this.level) : super([level]);

  @override
  String toString() => 'AudioRecordingLevelChanged: { level: $level }';
}

@immutable
class AudioPlaybackProgressChanged extends AudioNoteEvent {
  final bool isPlaying;
  final double progress;

  AudioPlaybackProgressChanged(this.isPlaying, this.progress)
      : super([isPlaying, progress]);

  @override
  String toString() => 'AudioPlaybackProgressChanged';
}
