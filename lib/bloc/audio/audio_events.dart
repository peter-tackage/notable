import 'package:equatable/equatable.dart';
import 'package:notable/model/audio_note.dart';

abstract class AudioNoteEvent extends Equatable {
  const AudioNoteEvent();

  @override
  List<Object> get props => [];
}

class LoadAudioNote extends AudioNoteEvent {
  final AudioNote audioNote;

  const LoadAudioNote(this.audioNote);

  @override
  List<Object> get props => [audioNote];

  @override
  String toString() => 'LoadAudioNote: {id: ${audioNote.id}';
}

class SaveAudioNote extends AudioNoteEvent { }

class DeleteAudioNote extends AudioNoteEvent { }

class ClearAudioNote extends AudioNoteEvent { }

class UpdateAudioNoteTitle extends AudioNoteEvent {
  final String title;

  const UpdateAudioNoteTitle(this.title);

  @override
  List<Object> get props => [title];

  @override
  String toString() => 'UpdateAudioNoteTitle: $title';
}

class StartAudioRecordingRequest extends AudioNoteEvent { }

class StopAudioRecordingRequest extends AudioNoteEvent { }

class StartAudioPlaybackRequest extends AudioNoteEvent { }

class PauseAudioPlaybackRequest extends AudioNoteEvent { }

class ResumeAudioPlaybackRequest extends AudioNoteEvent { }

class StopAudioPlaybackRequest extends AudioNoteEvent { }

class AudioRecordingProgressChanged extends AudioNoteEvent {
  final bool isRecording;
  final int progress;

  const AudioRecordingProgressChanged(this.isRecording, this.progress);

  @override
  List<Object> get props => [isRecording, progress];

  @override
  String toString() =>
      'AudioRecordingProgressChanged: { isRecording: $isRecording, progress: $progress}';
}

class AudioRecordingLevelChanged extends AudioNoteEvent {
  final double level;

  const AudioRecordingLevelChanged(this.level);

  @override
  List<Object> get props => [level];

  @override
  String toString() => 'AudioRecordingLevelChanged: { level: $level }';
}

class AudioPlaybackProgressChanged extends AudioNoteEvent {
  final bool isPlaying;
  final int progress;

  const AudioPlaybackProgressChanged(this.isPlaying, this.progress);

  @override
  List<Object> get props => [isPlaying, progress];

  @override
  String toString() => 'AudioPlaybackProgressChanged';
}
