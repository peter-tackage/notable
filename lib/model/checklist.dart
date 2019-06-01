import 'package:meta/meta.dart';
import 'package:notable/model/base_note.dart';
import 'package:uuid/uuid.dart';

@immutable
class Checklist extends BaseNote {
  final List<ChecklistItem> items;

  // final Sorting sorting;

  Checklist(title, labels, this.items, {id, updatedDate})
      : super(title, labels, id: id, updatedDate: updatedDate);

  Checklist copyWith(
      {String title, List<ChecklistItem> items, Sorting sorting}) {
    return Checklist(title ?? this.title, this.labels, items ?? this.items,
        // sorting ?? this.sorting,
        id: id,
        updatedDate: updatedDate);
  }

  @override
  String toString() {
    return 'Checklist: $title';
  }
}

@immutable
class ChecklistItem {
  final String task;
  final bool isDone;
  final String id;

  ChecklistItem(this.task, this.isDone, this.id);

  ChecklistItem.empty()
      : this.task = '',
        this.isDone = false,
        this.id = Uuid().v1().toString();

  isEmpty() => (task == null || task.trim().isEmpty) && isDone == false;

  @override
  String toString() {
    return 'ChecklistItem: $task';
  }

  ChecklistItem copyWith({String task, bool isDone}) {
    return ChecklistItem(task ?? this.task, isDone ?? this.isDone, this.id);
  }
}

enum Sorting { CREATION, DONE }
