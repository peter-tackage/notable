import 'package:built_collection/built_collection.dart';
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
      model.displayedActions.map(_mapActionToEntity).toList(),
      // trim to the current index
      id: model.id,
      updatedDate: model.updatedDate);

  static DrawingActionEntity _mapActionToEntity(DrawingAction action) {
    if (action is BrushAction) {
      return BrushDrawingActionEntity(
          action.points
              .map((OffsetValue offset) => PointEntity(offset.dx, offset.dy))
              .toList(),
          action.color,
          action.alpha,
          _mapPenShapeModelToEntity(action.penShape),
          action.strokeWidth);
    } else if (action is EraserAction) {
      return EraserDrawingActionEntity(
          action.points
              .map((OffsetValue offset) => PointEntity(offset.dx, offset.dy))
              .toList(),
          _mapPenShapeModelToEntity(action.penShape),
          action.strokeWidth);
    } else {
      throw Exception(
          "Cannot map to entity - unsupported drawing action: $action");
    }
  }

  @override
  toModel(DrawingEntity entity) => Drawing((b) => b
    ..title = entity.title
    ..labels = ListBuilder(entity.labels.map(Label.fromEntity))
    ..actions = ListBuilder(entity.actions.map(_mapActionEntityToModel))
    ..currentIndex = entity.actions.length - 1 // last index
    ..id = entity.id
    ..updatedDate = entity.updatedDate);

  DrawingAction _mapActionEntityToModel(DrawingActionEntity actionEntity) {
    if (actionEntity.tool == Tool.Brush.toString()) {
      return _mapBrushActionEntityToModel(
          actionEntity as BrushDrawingActionEntity);
    } else if (actionEntity.tool == Tool.Eraser.toString()) {
      return _mapEraserActionEntityToModel(
          actionEntity as EraserDrawingActionEntity);
    } else {
      throw Exception(
          "Cannot map entity to model - unsupported drawing action tool: ${actionEntity.tool}");
    }
  }

  static EraserAction _mapEraserActionEntityToModel(
      EraserDrawingActionEntity eraserActionEntity) {
    return EraserAction((b) => b
      ..points = ListBuilder(
          eraserActionEntity.points.map((pointEntity) => OffsetValue((sb) => sb
            ..dx = pointEntity.x
            ..dy = pointEntity.y)))
      ..penShape = _mapPenShapeEntityToModel(eraserActionEntity.penShape)
      ..strokeWidth = eraserActionEntity.strokeWidth);
  }

  static BrushAction _mapBrushActionEntityToModel(
      BrushDrawingActionEntity brushActionEntity) {
    return BrushAction((b) => b
      ..points = ListBuilder(
          brushActionEntity.points.map((pointEntity) => OffsetValue((sb) => sb
            ..dx = pointEntity.x
            ..dy = pointEntity.y)))
      ..color = brushActionEntity.color
      ..alpha = brushActionEntity.alpha
      ..penShape = _mapPenShapeEntityToModel(brushActionEntity.penShape)
      ..strokeWidth = brushActionEntity.strokeWidth);
  }

  static PenShape _mapPenShapeEntityToModel(PenShapeEntity penShapeEntity) {
    switch (penShapeEntity) {
      case PenShapeEntity.Square:
        return PenShape.Square;
      case PenShapeEntity.Round:
        return PenShape.Round;
      default:
        throw Exception("Can't map PenShapeEntity: $penShapeEntity");
    }
  }

  static PenShapeEntity _mapPenShapeModelToEntity(PenShape penShape) {
    switch (penShape) {
      case PenShape.Square:
        return PenShapeEntity.Square;
      case PenShape.Round:
        return PenShapeEntity.Round;
      default:
        throw Exception("Can't map PenShape: $penShape");
    }
  }
}
