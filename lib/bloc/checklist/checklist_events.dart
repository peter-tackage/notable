import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/checklist.dart';

@immutable
abstract class ChecklistEvent extends Equatable {
  ChecklistEvent([List props = const []]) : super(props);
}

@immutable
class LoadChecklist extends ChecklistEvent {
  final Checklist checklist;

  LoadChecklist(this.checklist) : super([checklist]);

  @override
  String toString() => 'LoadChecklist: {id: ${checklist.id}}';
}

@immutable
class SaveChecklist extends ChecklistEvent {
  SaveChecklist() : super([]);

  @override
  String toString() => 'SaveChecklist';
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
class SetChecklistItem extends ChecklistEvent {
  final int index;
  final ChecklistItem item;

  SetChecklistItem(this.index, this.item) : super([index, item]);

  @override
  String toString() => 'SetChecklistItem: $item';
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
