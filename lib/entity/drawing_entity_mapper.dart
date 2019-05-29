import 'package:notable/entity/drawing_entity.dart';
import 'package:notable/storage/entity_mapper.dart';

class DrawingEntityMapper implements EntityMapper<DrawingEntity> {
  @override
  DrawingEntity toEntity(Map json) => DrawingEntity.fromJson(json);
}
