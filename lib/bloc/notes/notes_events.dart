import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/base_note.dart';

@immutable
abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

@immutable
class LoadNotes extends NotesEvent { }

@immutable
class AddNote extends NotesEvent {
  final BaseNote note;

  const AddNote(this.note);

  @override
  List<Object> get props => [note];

  @override
  String toString() => 'AddNote: $note';
}

@immutable
class UpdateNote extends NotesEvent {
  final BaseNote note;

  const UpdateNote(this.note);

  @override
  List<Object> get props => [note];

  @override
  String toString() => 'UpdateEvent: $note';
}

@immutable
class DeleteNote extends NotesEvent {
  final String id;

  const DeleteNote(this.id);

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'DeleteNote: $id';
}
