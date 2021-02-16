import 'package:equatable/equatable.dart';
import 'package:notable/model/base_note.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class LoadNotes extends NotesEvent {}

class AddNote extends NotesEvent {
  final BaseNote note;

  const AddNote(this.note);

  @override
  List<Object> get props => [note];

  @override
  String toString() => 'AddNote: $note';
}

class UpdateNote extends NotesEvent {
  final BaseNote note;

  const UpdateNote(this.note);

  @override
  List<Object> get props => [note];

  @override
  String toString() => 'UpdateEvent: $note';
}

class DeleteNote extends NotesEvent {
  final String id;

  const DeleteNote(this.id);

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'DeleteNote: $id';
}
