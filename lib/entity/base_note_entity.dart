import 'package:notable/entity/base_entity.dart';

abstract class BaseNoteEntity extends BaseEntity {
  final String title;
  final List<LabelEntity> labels;

  BaseNoteEntity(this.title, this.labels, {id, updatedDate})
      : super(id: id, updatedDate: updatedDate);
}

class LabelEntity {
  final String name;
  final String color;

  LabelEntity(this.name, this.color);
}
