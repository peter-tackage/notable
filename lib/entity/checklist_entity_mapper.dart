import 'package:notable/entity/entity.dart';
import 'package:notable/storage/entity_mapper.dart';

class ChecklistEntityMapper implements EntityMapper<ChecklistEntity> {
  @override
  ChecklistEntity toEntity(Map json) => ChecklistEntity.fromJson(json);
}
