import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/note.dart';

@immutable
abstract class NotesEvent extends Equatable {
  NotesEvent([List props = const []]) : super(props);
}

@immutable
class LoadNotes extends NotesEvent {
  LoadNotes() : super();

  @override
  String toString() => 'ScreenStarted';
}

@immutable
class AddNote extends NotesEvent {
  final Note note;

  AddNote(this.note) : super([note]);

  @override
  String toString() => 'AddNote: $note';
}

@immutable
class UpdateNote extends NotesEvent {
  final Note note;

  UpdateNote(this.note) : super([note]);

  @override
  String toString() => 'UpdateEvent: $note';
}

@immutable
class DeleteNote extends NotesEvent {
  final String id;

  DeleteNote(this.id) : super([id]);

  @override
  String toString() => 'DeleteNote: $id';
}
