import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/note.dart';

@immutable
class NotesState extends Equatable {
  final List<Note> notes;
  final bool isLoading;

  NotesState(this.notes, this.isLoading) : super([notes, isLoading]);
}
