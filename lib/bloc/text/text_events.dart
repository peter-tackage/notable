import 'package:equatable/equatable.dart';
import 'package:notable/model/text_note.dart';

abstract class TextNoteEvent extends Equatable {
  const TextNoteEvent();

  @override
  List<Object> get props => [];
}

class LoadTextNote extends TextNoteEvent {
  final TextNote textNote;

  const LoadTextNote(this.textNote);

  @override
  List<Object> get props => [textNote];

  @override
  String toString() => 'LoadTextNote: {id: ${textNote.id}';
}

class SaveTextNote extends TextNoteEvent {}

class DeleteTextNote extends TextNoteEvent {}

class UpdateTextNoteTitle extends TextNoteEvent {
  final String title;

  const UpdateTextNoteTitle(this.title);

  @override
  List<Object> get props => [title];

  @override
  String toString() => 'UpdateTextNoteTitle: $title';
}

class UpdateTextNoteText extends TextNoteEvent {
  final String text;

  const UpdateTextNoteText(this.text);

  @override
  List<Object> get props => [text];

  @override
  String toString() => 'UpdateTextNoteText: $text';
}
