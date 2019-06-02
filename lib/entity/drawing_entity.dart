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
  @_DrawingActionConverter()
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

@JsonSerializable()
abstract class DrawingActionEntity {
  final String tool;

  DrawingActionEntity(this.tool);

  factory DrawingActionEntity.fromJson(Map<String, dynamic> json) =>
      _$DrawingActionEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DrawingActionEntityToJson(this);
}

//
// FIXME This JSON serialization is not very neat and certainly the package
// seems not designed to support inheritance.
//
// It only serializes the entries which are in the constructor, so you end up
// duplicating the information. It need some sort of tool key to allow deserialization
// back to objects - so that it tell which one to instantiate (see _DrawingActionConverter).
//

@JsonSerializable()
class BrushDrawingActionEntity extends DrawingActionEntity {
  final List<PointEntity> points;
  final int color;

  BrushDrawingActionEntity(this.points, this.color, {String tool = brushTool})
      : super(tool);

  factory BrushDrawingActionEntity.fromJson(Map<String, dynamic> json) =>
      _$BrushDrawingActionEntityFromJson(json);

  Map<String, dynamic> toJson() => _$BrushDrawingActionEntityToJson(this);
}

@JsonSerializable()
class EraserDrawingActionEntity extends DrawingActionEntity {
  final List<PointEntity> points;

  EraserDrawingActionEntity(this.points, {String tool = eraserTool})
      : super(tool);

  factory EraserDrawingActionEntity.fromJson(Map<String, dynamic> json) =>
      _$EraserDrawingActionEntityFromJson(json);

  Map<String, dynamic> toJson() => _$EraserDrawingActionEntityToJson(this);
}

class _DrawingActionConverter<DrawingActionEntity>
    implements JsonConverter<DrawingActionEntity, Object> {
  const _DrawingActionConverter();

  @override
  DrawingActionEntity fromJson(Object json) {
    if (json is Map<String, dynamic> &&
        json.containsKey('tool') &&
        json['tool'] == brushTool) {
      print("Making brush entity from json");
      return BrushDrawingActionEntity.fromJson(json) as DrawingActionEntity;
    }
    if (json is Map<String, dynamic> &&
        json.containsKey('tool') &&
        json['tool'] == eraserTool) {
      print("Making eraser entity from json");
      return EraserDrawingActionEntity.fromJson(json) as DrawingActionEntity;
    }

    throw Exception("Can't make DrawingActionEntity from JSON: $json");
  }

  @override
  Object toJson(DrawingActionEntity object) {
    // This will only work if `object` is a native JSON type:
    //   num, String, bool, null, etc
    // Or if it has a `toJson()` function`.
    return object;
  }
}
