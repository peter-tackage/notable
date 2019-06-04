import 'package:meta/meta.dart';

@immutable
class AudioPlayback {
  final String filename;
  final PlaybackState playbackState;
  final int length;
  final int progress;
  final int volume;

  AudioPlayback(this.filename, this.playbackState, this.length, this.progress,
      this.volume);

  @override
  String toString() => 'AudioPlayback: { playbackState: $playbackState } ';

  AudioPlayback copyWith(
          PlaybackState playbackState, int progress, int volume) =>
      AudioPlayback(this.filename, this.playbackState, this.length, progress,
          this.volume);
}

enum PlaybackState { Idle, Playing, Paused }
