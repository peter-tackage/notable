import 'package:meta/meta.dart';
import 'package:notable/entity/entity.dart';

@immutable
abstract class BaseNote {
  final String id;
  final DateTime updatedDate;
  final String title;
  final List<Label> labels;

  BaseNote(this.title, this.labels, {this.id, this.updatedDate});
}

@immutable
class Label {
  final String name;
  final String color;

  Label(this.name, this.color);

  LabelEntity toEntity() => LabelEntity(name, color);

  static Label fromEntity(LabelEntity entity) =>
      Label(entity.name, entity.color);
}
