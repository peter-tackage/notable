import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/checklist.dart';

@immutable
abstract class ChecklistEvent extends Equatable {
  const ChecklistEvent();

  @override
  List<Object> get props => [];
}

@immutable
class LoadChecklist extends ChecklistEvent {
  final Checklist checklist;

  const LoadChecklist(this.checklist);

  @override
  List<Object> get props => [checklist];

  @override
  String toString() => 'LoadChecklist: {id: ${checklist.id}}';
}

@immutable
class SaveChecklist extends ChecklistEvent { }

@immutable
class DeleteChecklist extends ChecklistEvent { }

@immutable
class UpdateChecklistTitle extends ChecklistEvent {
  final String title;

  const UpdateChecklistTitle(this.title);

  @override
  List<Object> get props => [title];

  @override
  String toString() => 'UpdateChecklistTitle: $title';
}

@immutable
class SetChecklistItem extends ChecklistEvent {
  final int index;
  final ChecklistItem item;

  const SetChecklistItem(this.index, this.item);

  @override
  List<Object> get props => [index, item];

  @override
  String toString() => 'SetChecklistItem: $item';
}

@immutable
class RemoveChecklistItem extends ChecklistEvent {
  final int index;

  const RemoveChecklistItem(this.index);

  @override
  List<Object> get props => [index];

  @override
  String toString() => 'RemoveChecklistItem: $index';
}

@immutable
class AddEmptyChecklistItem extends ChecklistEvent { }
