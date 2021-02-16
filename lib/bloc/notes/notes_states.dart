import 'package:equatable/equatable.dart';
import 'package:notable/model/base_note.dart';

abstract class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object> get props => [];
}

class NotesLoading extends NotesState {}

class NotesLoaded extends NotesState {
  final List<BaseNote> notes;

  NotesLoaded(this.notes) : super();

  @override
  List<Object> get props => [notes];

  @override
  String toString() => 'NotesLoaded { notes: $notes }';
}
