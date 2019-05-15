// TODO Make this a proper entity class
class NoteEntity {
  final String id;
  final String task;
  final String content;
  final List<String> labels;
  final DateTime createdDate;

  NoteEntity(
    this.id,
    this.task,
    this.content,
    this.labels,
    this.createdDate,
  );

  NoteEntity copyWith(String id) {
    return NoteEntity(
        id, this.task, this.content, this.labels, this.createdDate);
  }
}
