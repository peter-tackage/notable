import 'package:json_annotation/json_annotation.dart';
import 'package:notable/entity/base_note_entity.dart';

import 'label_entity.dart';

part 'note_entity.g.dart';

@JsonSerializable(nullable: false)
class NoteEntity extends BaseNoteEntity {
  final String text;

  NoteEntity(List<LabelEntity> labels, String title, this.text,
      {String id, DateTime updatedDate})
      : super(title, labels, id: id, updatedDate: updatedDate);

  factory NoteEntity.fromJson(Map<String, dynamic> json) =>
      _$NoteEntityFromJson(json);

  Map<String, dynamic> toJson() => _$NoteEntityToJson(this);
}
