import 'package:meta/meta.dart';
import 'package:notable/entity/note_entity.dart';

@immutable
class Note {
  final String id;
  final String title;
  final String content;
  final List<String> labels;
  final DateTime createdDate;

  Note(this.title, this.content, this.labels, this.createdDate, {this.id});

  @override
  String toString() {
    return 'Note: $title';
  }

  NoteEntity toEntity() {
    return NoteEntity(id, title, content, labels, createdDate);
  }

  static Note fromEntity(NoteEntity noteEntity) {
    return Note(noteEntity.title, noteEntity.content, noteEntity.labels,
        noteEntity.createdDate);
  }
}
