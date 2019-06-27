import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/base_note.dart';
import 'package:notable/model/label.dart';

part 'audio_note.g.dart';

@immutable
abstract class AudioNote
    implements BaseNote, Built<AudioNote, AudioNoteBuilder> {
  @nullable
  String get filename;

  double get length;

  AudioNote._();

  factory AudioNote([updates(AudioNoteBuilder b)]) = _$AudioNote;
}
