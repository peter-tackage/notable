import 'package:built_value/built_value.dart';
import 'package:meta/meta.dart';
import 'package:notable/entity/label_entity.dart';

part 'label.g.dart';

@immutable
abstract class Label implements Built<Label, LabelBuilder> {
  String get name;

  String get color;

  Label._();

  factory Label([updates(LabelBuilder b)]) = _$Label;

  //
  // Mappers
  //

  LabelEntity toEntity() => LabelEntity(name, color);

  static Label fromEntity(LabelEntity entity) => Label((b) => b
    ..name = entity.name
    ..color = entity.color);
}
