import 'package:meta/meta.dart';
import 'package:notable/entity/note_entity.dart';

@immutable
class Note {
  final String id;
  final String task;
  final String content;
  final List<String> labels;
  final DateTime createdDate;

  Note(this.task, this.content, this.labels, this.createdDate, {this.id});

  @override
  String toString() {
    return 'Note: $task';
  }

  NoteEntity toEntity() {
    return NoteEntity(id, task, content, labels, createdDate);
  }

  static Note fromEntity(NoteEntity noteEntity) {
    return Note(noteEntity.task, noteEntity.content, noteEntity.labels,
        noteEntity.createdDate,
        id: noteEntity.id);
  }
}
