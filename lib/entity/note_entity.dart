import 'package:json_annotation/json_annotation.dart';
import 'package:notable/entity/base_note_entity.dart';

import 'label_entity.dart';

part 'note_entity.g.dart';

@JsonSerializable(nullable: false)
class TextNoteEntity extends BaseNoteEntity {
  final String text;

  TextNoteEntity(List<LabelEntity> labels, String title, this.text,
      {String id, DateTime updatedDate})
      : super(title, labels, id: id, updatedDate: updatedDate);

  factory TextNoteEntity.fromJson(Map<String, dynamic> json) =>
      _$TextNoteEntityFromJson(json);

  Map<String, dynamic> toJson() => _$TextNoteEntityToJson(this);
}
