// TODO Make this a proper entity class

import 'package:notable/entity/base_note_entity.dart';

class ChecklistEntity extends BaseNoteEntity {
  final List<ChecklistItemEntity> items;

  ChecklistEntity(labels, title, this.items, {id, updatedDate})
      : super(title, labels, id: id, updatedDate: updatedDate);
}

class ChecklistItemEntity {
  final String item;
  final bool isDone;

  ChecklistItemEntity(this.item, this.isDone);
}
