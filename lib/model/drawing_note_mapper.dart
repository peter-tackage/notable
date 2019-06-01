import 'dart:ui';

import 'package:notable/data/mapper.dart';
import 'package:notable/entity/drawing_entity.dart';
import 'package:notable/model/drawing.dart';
import 'package:notable/model/drawing_config.dart';
import 'package:notable/model/label.dart';

class DrawingMapper implements Mapper<Drawing, DrawingEntity> {
  @override
  toEntity(Drawing model) => DrawingEntity(
      model.labels.map((label) => label.toEntity()).toList(),
      model.title,
      model.allActions.map(_mapActionToEntity).toList(),
      id: model.id,
      updatedDate: model.updatedDate);

  static DrawingActionEntity _mapActionToEntity(DrawingAction action) {
    if (action is BrushAction) {
      return BrushDrawingActionEntity(
          action.points
              .map((Offset offset) => PointEntity(offset.dx, offset.dy))
              .toList(),
          action.color.value);
    } else if (action is EraserAction) {
      return EraserDrawingActionEntity(action.points
          .map((Offset offset) => PointEntity(offset.dx, offset.dy))
          .toList());
    } else {
      throw Exception(
          "Cannot map to entity - unsupported drawing action: $action");
    }
  }

  @override
  toModel(DrawingEntity entity) => Drawing(
      entity.title,
      entity.labels.map(Label.fromEntity).toList(),
      entity.actions.map(_mapActionToModel).toList(),
      entity.actions.length - 1, // last index
      id: entity.id,
      updatedDate: entity.updatedDate);

  _mapActionToModel(DrawingActionEntity actionEntity) {
    if (actionEntity.tool == Tool.Brush.toString()) {
      return _mapToBrushActionEntity(actionEntity);
    } else if (actionEntity.tool == Tool.Eraser.toString()) {
      return _mapToEraserActionEntity(actionEntity);
    } else {
      throw Exception(
          "Cannot map entity to model - unsupported drawing action tool: ${actionEntity.tool}");
    }
  }

  static EraserAction _mapToEraserActionEntity(
      DrawingActionEntity actionEntity) {
    EraserDrawingActionEntity eraserEntity =
        actionEntity as EraserDrawingActionEntity;

    return EraserAction(eraserEntity.points
        .map((pointEntity) => Offset(pointEntity.x, pointEntity.y))
        .toList());
  }

  static BrushAction _mapToBrushActionEntity(DrawingActionEntity actionEntity) {
    BrushDrawingActionEntity brushEntity =
        actionEntity as BrushDrawingActionEntity;

    return BrushAction(
        brushEntity.points
            .map((pointEntity) => Offset(pointEntity.x, pointEntity.y))
            .toList(),
        Color(brushEntity.color));
  }
}
