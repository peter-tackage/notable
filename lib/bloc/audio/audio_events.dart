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
  String toString() => 'SaveDrawing';
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
