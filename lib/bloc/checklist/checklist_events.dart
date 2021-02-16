import 'package:equatable/equatable.dart';
import 'package:notable/model/checklist.dart';

abstract class ChecklistEvent extends Equatable {
  const ChecklistEvent();

  @override
  List<Object> get props => [];
}

class LoadChecklist extends ChecklistEvent {
  final Checklist checklist;

  const LoadChecklist(this.checklist);

  @override
  List<Object> get props => [checklist];

  @override
  String toString() => 'LoadChecklist: {id: ${checklist.id}}';
}

class SaveChecklist extends ChecklistEvent {}

class DeleteChecklist extends ChecklistEvent {}

class UpdateChecklistTitle extends ChecklistEvent {
  final String title;

  const UpdateChecklistTitle(this.title);

  @override
  List<Object> get props => [title];

  @override
  String toString() => 'UpdateChecklistTitle: $title';
}

class SetChecklistItem extends ChecklistEvent {
  final int index;
  final ChecklistItem item;

  const SetChecklistItem(this.index, this.item);

  @override
  List<Object> get props => [index, item];

  @override
  String toString() => 'SetChecklistItem: $item';
}

class RemoveChecklistItem extends ChecklistEvent {
  final int index;

  const RemoveChecklistItem(this.index);

  @override
  List<Object> get props => [index];

  @override
  String toString() => 'RemoveChecklistItem: $index';
}

class AddEmptyChecklistItem extends ChecklistEvent {}
