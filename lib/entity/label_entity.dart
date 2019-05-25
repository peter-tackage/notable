import 'package:json_annotation/json_annotation.dart';

part 'label_entity.g.dart';

@JsonSerializable(nullable: false)
class LabelEntity {
  final String name;
  final String color;

  LabelEntity(this.name, this.color);

  factory LabelEntity.fromJson(Map<String, dynamic> json) => _$LabelEntityFromJson(json);

  Map<String, dynamic> toJson() => _$LabelEntityToJson(this);
}