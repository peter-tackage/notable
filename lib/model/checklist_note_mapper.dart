import 'package:built_collection/built_collection.dart';
import 'package:notable/data/mapper.dart';
import 'package:notable/entity/entity.dart';
import 'package:notable/model/checklist.dart';
import 'package:notable/model/label.dart';

class ChecklistMapper implements Mapper<Checklist, ChecklistEntity> {
  @override
  toEntity(Checklist model) => ChecklistEntity(
      model.labels.map((l) => l.toEntity()).toList(),
      model.title,
      model.items
          .map((item) => ChecklistItemEntity(item.task, item.isDone, item.id))
          .toList(),
      id: model.id,
      updatedDate: model.updatedDate);

  @override
  toModel(ChecklistEntity entity) => Checklist((b) => b
    ..title = entity.title
    ..labels = ListBuilder(entity.labels.map(Label.fromEntity))
    ..items = ListBuilder(entity.items.map((item) => ChecklistItem((bi) => bi
      ..task = item.task
      ..isDone = item.isDone
      ..id = item.id)))
    ..id = entity.id
    ..updatedDate = entity.updatedDate);
}
