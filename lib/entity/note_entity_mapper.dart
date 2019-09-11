import 'package:notable/entity/entity.dart';
import 'package:notable/storage/entity_mapper.dart';

class NoteEntityMapper implements EntityMapper<TextNoteEntity> {
  @override
  TextNoteEntity toEntity(Map json) => TextNoteEntity.fromJson(json);
}
