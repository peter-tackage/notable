import 'package:notable/data/base_entity.dart';
import 'package:notable/entity/label_entity.dart';

abstract class BaseNoteEntity extends BaseEntity {
  final String title;
  final List<LabelEntity> labels;

  BaseNoteEntity(this.title, this.labels, {id, updatedDate})
      : super(id: id, updatedDate: updatedDate);

}
