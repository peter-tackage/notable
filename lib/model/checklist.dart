import 'package:meta/meta.dart';
import 'package:notable/model/base_note.dart';

@immutable
class Checklist extends BaseNote {
  final List<ChecklistItem> items;

  Checklist(title, labels, this.items, {id, updatedDate})
      : super(title, labels, id: id, updatedDate: updatedDate);

  Checklist copyWith({String title, List<ChecklistItem> items}) {
    return Checklist(title ?? this.title, this.labels, items ?? this.items,
        id: id, updatedDate: updatedDate);
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

  ChecklistItem(this.task, this.isDone);

  ChecklistItem.empty()
      : this.task = '',
        this.isDone = false;

  isEmpty() => (task == null || task.trim().isEmpty) && isDone == false;

  @override
  String toString() {
    return 'ChecklistItem: $task';
  }

  ChecklistItem copyWith({String task, bool isDone}) {
    return ChecklistItem(task ?? this.task, isDone ?? this.isDone);
  }
}
