import 'package:json_annotation/json_annotation.dart';
import 'package:notable/entity/base_note_entity.dart';

import 'label_entity.dart';

part 'audio_note_entity.g.dart';

@JsonSerializable(nullable: false)
class AudioNoteEntity extends BaseNoteEntity {
  final String filename;

  AudioNoteEntity(List<LabelEntity> labels, String title, this.filename,
      {String id, DateTime updatedDate})
      : super(title, labels, id: id, updatedDate: updatedDate);

  factory AudioNoteEntity.fromJson(Map<String, dynamic> json) =>
      _$AudioNoteEntityFromJson(json);

  Map<String, dynamic> toJson() => _$AudioNoteEntityToJson(this);
}
