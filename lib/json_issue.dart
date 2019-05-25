import 'package:json_annotation/json_annotation.dart';

part 'json_issue.g.dart';

//@JsonSerializable()
class Base {
  final List<BaseItem> baseItems;

  Base(this.baseItems);

//  factory Base.fromJson(Map<String, dynamic> json) => _$BaseFromJson(json);
//
//  Map<String, dynamic> toJson() => _$BaseToJson(this);
}

@JsonSerializable()
class BaseItem {
  final String itemValue;

  BaseItem(this.itemValue);

  factory BaseItem.fromJson(Map<String, dynamic> json) =>
      _$BaseItemFromJson(json);

  Map<String, dynamic> toJson() => _$BaseItemToJson(this);
}

@JsonSerializable()
class Child extends Base {

  Child(List<BaseItem> baseItems) : super(baseItems);

  factory Child.fromJson(Map<String, dynamic> json) =>
      _$ChildFromJson(json);

  Map<String, dynamic> toJson() => _$ChildToJson(this);
}

