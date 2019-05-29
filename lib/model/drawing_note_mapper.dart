import 'package:notable/data/mapper.dart';
import 'package:notable/entity/drawing_entity.dart';
import 'package:notable/model/drawing.dart';

class DrawingMapper implements Mapper<Drawing, DrawingEntity> {
  @override
  toEntity(Drawing model) => null;

//      DrawingEntity(
//      model.labels.map((l) => l.toEntity()).toList(),
//      model.title,
//      model.allActions
//          .map((action) => DrawingActionEntity(action., item.isDone))
//          .toList(),
//
//      id: model.id,
//      updatedDate: model.updatedDate);

  @override
  toModel(DrawingEntity entity) => null;

//      Drawing(
//      entity.title,
//      entity.labels.map(Label.fromEntity).toList(),
//      entity.actions
//          .map((item) => DrawingAction(item.task, item.isDone))
//          .toList(),
//      id: entity.id,
//      updatedDate: entity.updatedDate);
}
