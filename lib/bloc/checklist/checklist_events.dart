import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/checklist.dart';

@immutable
abstract class ChecklistEvent extends Equatable {
  ChecklistEvent([List props = const []]) : super(props);
}

@immutable
class LoadChecklist extends ChecklistEvent {
  final String id;

  LoadChecklist(this.id) : super([id]);

  @override
  String toString() => 'LoadChecklist: $id';
}

@immutable
class AddChecklist extends ChecklistEvent {
  final Checklist checklist;

  AddChecklist(this.checklist) : super([checklist]);

  @override
  String toString() => 'AddChecklist: $checklist';
}

@immutable
class UpdateChecklist extends ChecklistEvent {
  final Checklist checklist;

  UpdateChecklist(this.checklist) : super([checklist]);

  @override
  String toString() => 'UpdateChecklist: $checklist';
}

@immutable
class DeleteChecklist extends ChecklistEvent {
  DeleteChecklist() : super([]);

  @override
  String toString() => 'DeleteChecklist';
}

@immutable
class UpdateChecklistTitle extends ChecklistEvent {
  final String title;

  UpdateChecklistTitle(this.title) : super([title]);

  @override
  String toString() => 'UpdateChecklistTitle: $title';
}

@immutable
class AddChecklistItem extends ChecklistEvent {
  final int index;
  final ChecklistItem item;

  AddChecklistItem(this.index, this.item) : super([index, item]);

  @override
  String toString() => 'AddChecklistItem: $item';
}

@immutable
class RemoveChecklistItem extends ChecklistEvent {
  final int index;

  RemoveChecklistItem(this.index) : super([index]);

  @override
  String toString() => 'RemoveChecklistItem: $index';
}

@immutable
class AddEmptyChecklistItem extends ChecklistEvent {
  AddEmptyChecklistItem() : super([]);

  @override
  String toString() => 'AddEmptyChecklistItem';
}
