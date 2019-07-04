import 'package:json_annotation/json_annotation.dart';
import 'package:notable/entity/base_note_entity.dart';

import 'label_entity.dart';

part 'drawing_entity.g.dart';

// TODO I might be better off suppling these through a factory or named ctor, rather than
// duplicating the String value of the enum.
const String brushTool = "Tool.Brush";
const String eraserTool = "Tool.Eraser";

@JsonSerializable()
class DrawingEntity extends BaseNoteEntity {
  @DrawingActionConverter()
  final List<DrawingActionEntity> actions;

  DrawingEntity(List<LabelEntity> labels, String title, this.actions,
      {String id, DateTime updatedDate})
      : super(title, labels, id: id, updatedDate: updatedDate);

  factory DrawingEntity.fromJson(Map<String, dynamic> json) =>
      _$DrawingEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DrawingEntityToJson(this);
}

@JsonSerializable()
class PointEntity {
  final double x;
  final double y;

  PointEntity(this.x, this.y);

  factory PointEntity.fromJson(Map<String, dynamic> json) =>
      _$PointEntityFromJson(json);

  Map<String, dynamic> toJson() => _$PointEntityToJson(this);
}

abstract class DrawingActionEntity {
  final String tool;

  DrawingActionEntity(this.tool);
}

//
// FIXME This JSON serialization is not very neat and certainly the package
// seems not designed to support inheritance.
//
// It only serializes the entries which are in the constructor, so you end up
// duplicating the information. It need some sort of tool key to allow deserialization
// back to objects - so that it tell which one to instantiate (see _DrawingActionConverter).
//

// FIXME Would be nicer if both color and alpha were stored as hex values.
@JsonSerializable(includeIfNull: false)
class BrushDrawingActionEntity extends DrawingActionEntity {
  final List<PointEntity> points;
  final int color;
  final int alpha; // range 0 to 255
  final PenShapeEntity penShape;
  final double strokeWidth;

  BrushDrawingActionEntity(
      this.points, this.color, this.alpha, this.penShape, this.strokeWidth,
      {tool = brushTool})
      : super(tool);

  factory BrushDrawingActionEntity.fromJson(Map<String, dynamic> json) =>
      _$BrushDrawingActionEntityFromJson(json);

  Map<String, dynamic> toJson() => _$BrushDrawingActionEntityToJson(this);
}

@JsonSerializable()
class EraserDrawingActionEntity extends DrawingActionEntity {
  final List<PointEntity> points;
  final PenShapeEntity penShape;
  final double strokeWidth;

  EraserDrawingActionEntity(this.points, this.penShape, this.strokeWidth,
      {tool = eraserTool})
      : super(tool);

  factory EraserDrawingActionEntity.fromJson(Map<String, dynamic> json) =>
      _$EraserDrawingActionEntityFromJson(json);

  Map<String, dynamic> toJson() => _$EraserDrawingActionEntityToJson(this);
}

enum PenShapeEntity { Square, Round }

class DrawingActionConverter
    implements JsonConverter<DrawingActionEntity, Object> {
  const DrawingActionConverter();

  @override
  DrawingActionEntity fromJson(Object json) {
    if (json is Map<String, dynamic> &&
        json.containsKey('tool') &&
        json['tool'] == brushTool) {
      return BrushDrawingActionEntity.fromJson(json);
    }
    if (json is Map<String, dynamic> &&
        json.containsKey('tool') &&
        json['tool'] == eraserTool) {
      return EraserDrawingActionEntity.fromJson(json);
    }

    throw Exception("Can't make DrawingActionEntity from JSON: $json");
  }

  @override
  Object toJson(DrawingActionEntity object) {
    if (object is BrushDrawingActionEntity) {
      return object.toJson();
    }

    if (object is EraserDrawingActionEntity) {
      return object.toJson();
    }

    throw Exception("Can't make JSON from DrawingActionEntity: $object");
  }
}
