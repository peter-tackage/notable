import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/text_note.dart';

@immutable
abstract class TextNoteEvent extends Equatable {
  TextNoteEvent([List props = const []]) : super(props);
}

@immutable
class LoadTextNote extends TextNoteEvent {
  final TextNote textNote;

  LoadTextNote(this.textNote) : super([textNote]);

  @override
  String toString() => 'LoadTextNote: {id: ${textNote.id}';
}

@immutable
class SaveTextNote extends TextNoteEvent {
  SaveTextNote() : super([]);

  @override
  String toString() => 'SaveTextNote';
}

@immutable
class DeleteTextNote extends TextNoteEvent {
  DeleteTextNote() : super([]);

  @override
  String toString() => 'DeleteTextNote';
}

@immutable
class UpdateTextNoteTitle extends TextNoteEvent {
  final String title;

  UpdateTextNoteTitle(this.title) : super([title]);

  @override
  String toString() => 'UpdateTextNoteTitle: $title';
}

@immutable
class UpdateTextNoteText extends TextNoteEvent {
  final String text;

  UpdateTextNoteText(this.text) : super([text]);

  @override
  String toString() => 'UpdateTextNoteText: $text';
}
