import 'package:built_collection/built_collection.dart';
import 'package:notable/data/mapper.dart';
import 'package:notable/entity/entity.dart';
import 'package:notable/model/label.dart';
import 'package:notable/model/text_note.dart';

class TextNoteMapper implements Mapper<TextNote, TextNoteEntity> {
  @override
  toEntity(TextNote model) => TextNoteEntity(
      model.labels.map((l) => l.toEntity()).toList(), model.title, model.text,
      id: model.id, updatedDate: model.updatedDate);

  @override
  toModel(TextNoteEntity entity) => TextNote((b) => b
    ..title = entity.title
    ..labels = ListBuilder(entity.labels.map(Label.fromEntity))
    ..text = entity.text
    ..id = entity.id
    ..updatedDate = entity.updatedDate);
}
