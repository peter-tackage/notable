import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/base_note.dart';

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
class TextNotesLoaded extends FeedEvent {
  final List<BaseNote> textNotes;

  TextNotesLoaded(this.textNotes) : super([textNotes]);

  @override
  String toString() => 'TextNotesLoaded';
}

@immutable
class ChecklistsLoaded extends FeedEvent {
  final List<BaseNote> checklists;

  ChecklistsLoaded(this.checklists) : super([checklists]);

  @override
  String toString() => 'ChecklistsLoaded';
}

@immutable
class DrawingsLoaded extends FeedEvent {
  final List<BaseNote> drawings;

  DrawingsLoaded(this.drawings) : super([drawings]);

  @override
  String toString() => 'DrawingsLoaded';
}
