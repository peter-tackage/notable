import 'package:notable/entity/entity.dart';
import 'package:notable/storage/entity_mapper.dart';

class NoteEntityMapper implements EntityMapper<NoteEntity> {
  @override
  NoteEntity toEntity(Map json) => NoteEntity.fromJson(json);
}
