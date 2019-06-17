import 'package:json_annotation/json_annotation.dart';
import 'package:notable/entity/base_note_entity.dart';

import 'label_entity.dart';

part 'checklist_entity.g.dart';

@JsonSerializable(nullable: false)
class ChecklistEntity extends BaseNoteEntity {
  final List<ChecklistItemEntity> items;

  ChecklistEntity(List<LabelEntity> labels, String title, this.items,
      {String id, DateTime updatedDate})
      : super(title, labels, id: id, updatedDate: updatedDate);

  factory ChecklistEntity.fromJson(Map<String, dynamic> json) =>
      _$ChecklistEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ChecklistEntityToJson(this);
}

@JsonSerializable(nullable: false)
class ChecklistItemEntity {
  final String task;
  final bool isDone;
  final String id;

  ChecklistItemEntity(this.task, this.isDone, this.id);

  factory ChecklistItemEntity.fromJson(Map<String, dynamic> json) =>
      _$ChecklistItemEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ChecklistItemEntityToJson(this);
}
