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
class DrawingActionEntity {
  // TODO Add these here

  DrawingActionEntity();

  factory DrawingActionEntity.fromJson(Map<String, dynamic> json) =>
      _$DrawingActionEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DrawingActionEntityToJson(this);
}
