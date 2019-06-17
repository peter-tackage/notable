import 'package:built_value/built_value.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/base_note.dart';
import 'package:notable/model/label.dart';

part 'text_note.g.dart';

@immutable
abstract class TextNote implements BaseNote, Built<TextNote, TextNoteBuilder> {
  String get text;

  @override
  String toString() => 'Note: $title';

  TextNote._();

  factory TextNote([updates(TextNoteBuilder b)]) = _$TextNote;
}
