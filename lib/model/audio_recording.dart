import 'package:built_value/built_value.dart';
import 'package:meta/meta.dart';

part 'audio_recording.g.dart';

@immutable
abstract class AudioRecording
    implements Built<AudioRecording, AudioRecordingBuilder> {
  RecordingState get recordingState;

  double get progress;

  double get level;

  AudioRecording._();

  factory AudioRecording([updates(AudioRecordingBuilder b)]) = _$AudioRecording;
}

enum RecordingState { Recording, Paused }
