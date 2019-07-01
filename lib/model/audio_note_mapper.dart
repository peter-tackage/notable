import 'package:built_collection/built_collection.dart';
import 'package:notable/data/mapper.dart';
import 'package:notable/entity/audio_note_entity.dart';
import 'package:notable/model/audio_note.dart';
import 'package:notable/model/label.dart';

class AudioNoteMapper implements Mapper<AudioNote, AudioNoteEntity> {
  @override
  toEntity(AudioNote model) => AudioNoteEntity(
      model.labels.map((l) => l.toEntity()).toList(),
      model.title,
      model.filename,
      model.lengthMillis,
      id: model.id,
      updatedDate: model.updatedDate);

  @override
  toModel(AudioNoteEntity entity) => AudioNote((b) => b
    ..title = entity.title
    ..labels = ListBuilder(entity.labels.map(Label.fromEntity))
    ..filename = entity.filename
    ..lengthMillis = entity.lengthMillis
    ..id = entity.id
    ..updatedDate = entity.updatedDate);
}
