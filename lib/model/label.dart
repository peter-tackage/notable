import 'package:meta/meta.dart';
import 'package:notable/entity/label_entity.dart';

@immutable
class Label {
  final String name;
  final String color;

  Label(this.name, this.color);

  LabelEntity toEntity() => LabelEntity(name, color);

  static Label fromEntity(LabelEntity entity) =>
      Label(entity.name, entity.color);
}