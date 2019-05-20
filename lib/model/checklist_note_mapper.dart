import 'package:notable/data/mapper.dart';
import 'package:notable/entity/entity.dart';
import 'package:notable/model/base_note.dart';
import 'package:notable/model/checklist.dart';

class ChecklistMapper implements Mapper<Checklist, ChecklistEntity> {
  @override
  toEntity(Checklist model) {
    return ChecklistEntity(
        model.labels.map((l) => l.toEntity()).toList(),
        model.title,
        model.items
            .map((item) => ChecklistItemEntity(item.task, item.isDone))
            .toList(),
        id: model.id,
        updatedDate: model.updatedDate);
  }

  @override
  toModel(ChecklistEntity entity) {
    return Checklist(
        entity.title,
        entity.labels.map(Label.fromEntity).toList(),
        entity.items
            .map((item) => ChecklistItem(item.task, item.isDone))
            .toList(),
        id: entity.id,
        updatedDate: entity.updatedDate);
  }
}
