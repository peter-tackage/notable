import 'package:built_value/built_value.dart';
import 'package:meta/meta.dart';

part 'audio_playback.g.dart';

@immutable
abstract class AudioPlayback
    implements Built<AudioPlayback, AudioPlaybackBuilder> {
  String get filename;

  PlaybackState get playbackState;

  int get length;

  int get progress;

  int get volume;

  AudioPlayback._();

  factory AudioPlayback([updates(AudioPlaybackBuilder b)]) = _$AudioPlayback;
}

enum PlaybackState { Idle, Playing, Paused }
