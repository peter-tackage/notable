import 'package:json_annotation/json_annotation.dart';
import 'package:notable/entity/base_note_entity.dart';

import 'label_entity.dart';

part 'drawing_entity.g.dart';

@JsonSerializable()
class DrawingEntity extends BaseNoteEntity {
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
class DrawingActionEntity {
  final List<PointEntity> points;
  final int color;

  DrawingActionEntity(this.points, this.color);

  factory DrawingActionEntity.fromJson(Map<String, dynamic> json) =>
      _$DrawingActionEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DrawingActionEntityToJson(this);
}
