import 'package:meta/meta.dart';

@immutable
class Note {
  final String title;
  final String content;
  final List<String> labels;
  final DateTime createdDate;

  Note(this.title, this.content, this.labels, this.createdDate);

  @override
  String toString() {
    return 'Note{title: $title}';
  }
}
