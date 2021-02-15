import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/text_note.dart';

@immutable
abstract class TextNoteEvent extends Equatable {
  const TextNoteEvent();

  @override
  List<Object> get props => [];
}

@immutable
class LoadTextNote extends TextNoteEvent {
  final TextNote textNote;

  const LoadTextNote(this.textNote);

  @override
  List<Object> get props => [textNote];

  @override
  String toString() => 'LoadTextNote: {id: ${textNote.id}';
}

@immutable
class SaveTextNote extends TextNoteEvent { }

@immutable
class DeleteTextNote extends TextNoteEvent { }

@immutable
class UpdateTextNoteTitle extends TextNoteEvent {
  final String title;

  const UpdateTextNoteTitle(this.title);

  @override
  List<Object> get props => [title];

  @override
  String toString() => 'UpdateTextNoteTitle: $title';
}

@immutable
class UpdateTextNoteText extends TextNoteEvent {
  final String text;

  const UpdateTextNoteText(this.text);

  @override
  List<Object> get props => [text];

  @override
  String toString() => 'UpdateTextNoteText: $text';
}
