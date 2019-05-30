import 'dart:ui';

import 'package:notable/data/mapper.dart';
import 'package:notable/entity/drawing_entity.dart';
import 'package:notable/model/drawing.dart';
import 'package:notable/model/label.dart';

class DrawingMapper implements Mapper<Drawing, DrawingEntity> {
  @override
  toEntity(Drawing model) => DrawingEntity(
      model.labels.map((label) => label.toEntity()).toList(),
      model.title,
      model.allActions
          .cast<BrushAction>()
          .map((action) => DrawingActionEntity(
              action.points
                  .map((Offset offset) => PointEntity(offset.dx, offset.dy))
                  .toList(),
              action.color.value))
          .toList(),
      id: model.id,
      updatedDate: model.updatedDate);

  @override
  toModel(DrawingEntity entity) => Drawing(
      entity.title,
      entity.labels.map(Label.fromEntity).toList(),
      entity.actions
          .map((action) => BrushAction(
              action.points
                  .map((pointEntity) => Offset(pointEntity.x, pointEntity.y))
                  .toList(),
              Color(action.color)))
          .toList(),
      entity.actions.length - 1, // last index
      id: entity.id,
      updatedDate: entity.updatedDate);
}
