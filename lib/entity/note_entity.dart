// TODO Make this a proper entity class
class NoteEntity {
  final String id;
  final String title;
  final String content;
  final List<String> labels;
  final DateTime createdDate;

  NoteEntity(
    this.id,
    this.title,
    this.content,
    this.labels,
    this.createdDate,
  );

  NoteEntity copyWith(String id) {
    return NoteEntity(
        id, this.title, this.content, this.labels, this.createdDate);
  }
}
