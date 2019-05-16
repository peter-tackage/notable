import 'package:meta/meta.dart';
import 'package:notable/model/base_note.dart';

@immutable
class Checklist extends BaseNote {
  final List<ChecklistItem> items;

  Checklist(title, labels, this.items, {id, createdDate})
      : super(title, labels, id: id, updatedDate: createdDate);

  @override
  String toString() {
    return 'Checklist: $title';
  }
}

@immutable
class ChecklistItem {
  final String text;
  final bool isDone;

  ChecklistItem(this.text, this.isDone);

  @override
  String toString() {
    return 'ChecklistItem: $text';
  }
}
