import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notable/bloc/notes/notes.dart';

@immutable
abstract class FeedEvent extends Equatable {
  FeedEvent([List props = const []]) : super(props);
}

@immutable
class LoadFeed extends FeedEvent {
  LoadFeed() : super([]);

  @override
  String toString() => 'LoadFeed';
}

@immutable
class NoteStatesChanged extends FeedEvent {
  final List<NotesState> noteStates;

  NoteStatesChanged(this.noteStates) : super([noteStates]);

  @override
  String toString() => 'NoteStatesChanged';
}
