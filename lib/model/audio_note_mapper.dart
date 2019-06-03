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
      id: model.id,
      updatedDate: model.updatedDate);

  @override
  toModel(AudioNoteEntity entity) => AudioNote(entity.title,
      entity.labels.map(Label.fromEntity).toList(), entity.filename,
      id: entity.id, createdDate: entity.updatedDate);
}
