import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notable/bloc/notes/notes.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object> get props => [];
}

class LoadFeed extends FeedEvent { }

class NoteStatesChanged extends FeedEvent {
  final List<NotesState> noteStates;

  const NoteStatesChanged(this.noteStates);

  @override
  List<Object> get props => [noteStates];

  @override
  String toString() => 'NoteStatesChanged';
}
