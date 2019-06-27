import 'package:built_value/built_value.dart';
import 'package:meta/meta.dart';

part 'audio_playback.g.dart';

@immutable
abstract class AudioPlayback
    implements Built<AudioPlayback, AudioPlaybackBuilder> {
  PlaybackState get playbackState;

  double get progress;

  int get volume;

  AudioPlayback._();

  factory AudioPlayback([updates(AudioPlaybackBuilder b)]) = _$AudioPlayback;
}

enum PlaybackState { Playing, Paused }
