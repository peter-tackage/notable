import 'package:meta/meta.dart';
import 'package:notable/entity/note_entity.dart';
import 'package:notable/model/base_note.dart';

@immutable
class Note extends BaseNote {
  final String text;

  Note(title, labels, this.text, {id, createdDate})
      : super(title, labels, id: id, updatedDate: createdDate);

  @override
  String toString() {
    return 'Note: $title';
  }

  Note copyWith(String title, String text) {
    return Note(title, this.labels, text,
        id: this.id, createdDate: this.updatedDate);
  }

  NoteEntity toEntity() =>
      NoteEntity(labels.map((l) => l.toEntity()).toList(), title, text,
          id: this.id, updatedDate: this.updatedDate);

  static Note fromEntity(NoteEntity noteEntity) => Note(noteEntity.title,
      noteEntity.labels.map(Label.fromEntity).toList(), noteEntity.text,
      id: noteEntity.id, createdDate: noteEntity.updatedDate);
}
