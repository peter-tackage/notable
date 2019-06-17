import 'package:built_value/built_value.dart';
import 'package:meta/meta.dart';

import 'label.dart';

part 'base_note.g.dart';

//
// This is amazingly tedious - https://github.com/google/built_value.dart/blob/master/example/lib/polymorphism.dart
//

@BuiltValue(instantiable: false)
@immutable
abstract class BaseNote {
  @nullable
  String get id;

  @nullable
  DateTime get updatedDate;

  String get title;

  List<Label> get labels; // TODO Why isn't this required to be a BuiltList

  BaseNote rebuild(void Function(BaseNoteBuilder) updates);

  BaseNoteBuilder toBuilder();
}
