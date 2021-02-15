import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notable/bloc/notes/notes.dart';

@immutable
abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object> get props => [];
}

@immutable
class LoadFeed extends FeedEvent { }

@immutable
class NoteStatesChanged extends FeedEvent {
  final List<NotesState> noteStates;

  const NoteStatesChanged(this.noteStates);

  @override
  List<Object> get props => [noteStates];

  @override
  String toString() => 'NoteStatesChanged';
}
