import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/audio_note.dart';

@immutable
abstract class AudioNoteEvent extends Equatable {
  const AudioNoteEvent();

  @override
  List<Object> get props => [];
}

@immutable
class LoadAudioNote extends AudioNoteEvent {
  final AudioNote audioNote;

  const LoadAudioNote(this.audioNote);

  @override
  List<Object> get props => [audioNote];

  @override
  String toString() => 'LoadAudioNote: {id: ${audioNote.id}';
}

@immutable
class SaveAudioNote extends AudioNoteEvent { }

@immutable
class DeleteAudioNote extends AudioNoteEvent { }

@immutable
class ClearAudioNote extends AudioNoteEvent { }

@immutable
class UpdateAudioNoteTitle extends AudioNoteEvent {
  final String title;

  const UpdateAudioNoteTitle(this.title);

  @override
  List<Object> get props => [title];

  @override
  String toString() => 'UpdateAudioNoteTitle: $title';
}

@immutable
class StartAudioRecordingRequest extends AudioNoteEvent { }

@immutable
class StopAudioRecordingRequest extends AudioNoteEvent { }

@immutable
class StartAudioPlaybackRequest extends AudioNoteEvent { }

@immutable
class PauseAudioPlaybackRequest extends AudioNoteEvent { }

@immutable
class ResumeAudioPlaybackRequest extends AudioNoteEvent { }

@immutable
class StopAudioPlaybackRequest extends AudioNoteEvent { }

@immutable
class AudioRecordingProgressChanged extends AudioNoteEvent {
  final bool isRecording;
  final double progress;

  const AudioRecordingProgressChanged(this.isRecording, this.progress);

  @override
  List<Object> get props => [isRecording, progress];

  @override
  String toString() =>
      'AudioRecordingProgressChanged: { isRecording: $isRecording, progress: $progress}';
}

@immutable
class AudioRecordingLevelChanged extends AudioNoteEvent {
  final double level;

  const AudioRecordingLevelChanged(this.level);

  @override
  List<Object> get props => [level];

  @override
  String toString() => 'AudioRecordingLevelChanged: { level: $level }';
}

@immutable
class AudioPlaybackProgressChanged extends AudioNoteEvent {
  final bool isPlaying;
  final double progress;

  const AudioPlaybackProgressChanged(this.isPlaying, this.progress);

  @override
  List<Object> get props => [isPlaying, progress];

  @override
  String toString() => 'AudioPlaybackProgressChanged';
}
