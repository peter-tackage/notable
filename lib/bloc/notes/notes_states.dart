import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/base_note.dart';

@immutable
abstract class NotesState extends Equatable {
  NotesState([List props = const []]) : super(props);
}

class NotesLoading extends NotesState {
  @override
  String toString() => 'NotesLoading';
}

class NotesLoaded extends NotesState {
  final List<BaseNote> notes;

  NotesLoaded(this.notes) : super([notes]);

  @override
  String toString() => 'NotesLoaded { notes: $notes }';
}
