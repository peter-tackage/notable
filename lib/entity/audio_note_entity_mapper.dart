import 'package:notable/entity/audio_note_entity.dart';
import 'package:notable/storage/entity_mapper.dart';

class AudioNoteEntityMapper implements EntityMapper<AudioNoteEntity> {
  @override
  AudioNoteEntity toEntity(Map json) => AudioNoteEntity.fromJson(json);
}
