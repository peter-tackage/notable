import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/base_note.dart';
import 'package:notable/model/label.dart';
import 'package:uuid/uuid.dart';

part 'checklist.g.dart';

@immutable
abstract class Checklist
    implements BaseNote, Built<Checklist, ChecklistBuilder> {
  BuiltList<ChecklistItem> get items;

  Checklist._();

  factory Checklist([updates(ChecklistBuilder b)]) = _$Checklist;
}

@immutable
abstract class ChecklistItem
    implements Built<ChecklistItem, ChecklistItemBuilder> {
  String get task;

  bool get isDone;

  String get id;

  static ChecklistItem empty() => ChecklistItem((b) => b
    ..task = ''
    ..isDone = false
    ..id = Uuid().v1().toString());

  bool get isEmpty => (task == null || task.trim().isEmpty) && isDone == false;

  ChecklistItem._();

  factory ChecklistItem([updates(ChecklistItemBuilder b)]) = _$ChecklistItem;
}

enum Sorting { CREATION, DONE }
