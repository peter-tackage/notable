import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/audio_note.dart';

@immutable
abstract class AudioNoteState extends Equatable {
  AudioNoteState([List props = const []]) : super(props);
}

class AudioNoteLoading extends AudioNoteState {
  @override
  String toString() => 'AudioNoteLoading';
}

class AudioNoteLoaded extends AudioNoteState {
  final AudioNote audioNote;

  AudioNoteLoaded(this.audioNote) : super([audioNote]);

  @override
  String toString() => 'AudioNoteLoaded { notes: $audioNote }';
}
