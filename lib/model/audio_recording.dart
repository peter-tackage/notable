import 'package:meta/meta.dart';

@immutable
class AudioRecording {
  final String filename;
  final RecordingState recordingState;
  final double progress;
  final double level;

  AudioRecording(this.filename, this.recordingState, this.progress, this.level);

  @override
  String toString() => 'AudioPlayback: { playbackState: $recordingState, ';

  AudioRecording copyWith(
          {RecordingState recordingState, double progress, double level}) =>
      AudioRecording(this.filename, recordingState ?? this.recordingState,
          progress ?? this.progress, level ?? this.level);
}

enum RecordingState { Recording, Recorded }
