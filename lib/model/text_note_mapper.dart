import 'package:notable/data/mapper.dart';
import 'package:notable/entity/entity.dart';
import 'package:notable/model/label.dart';
import 'package:notable/model/text_note.dart';

class TextNoteMapper implements Mapper<TextNote, NoteEntity> {
  @override
  toEntity(TextNote model) => NoteEntity(
      model.labels.map((l) => l.toEntity()).toList(), model.title, model.text,
      id: model.id, updatedDate: model.updatedDate);

  @override
  toModel(NoteEntity entity) => TextNote(
      entity.title, entity.labels.map(Label.fromEntity).toList(), entity.text,
      id: entity.id, createdDate: entity.updatedDate);
}
