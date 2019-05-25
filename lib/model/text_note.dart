import 'package:meta/meta.dart';
import 'package:notable/model/base_note.dart';

@immutable
class TextNote extends BaseNote {
  final String text;

  TextNote(title, labels, this.text, {id, createdDate})
      : super(title, labels, id: id, updatedDate: createdDate);

  @override
  String toString() => 'Note: $title';

  TextNote copyWith(String title, String text) =>
      TextNote(title, this.labels, text,
          id: this.id, createdDate: this.updatedDate);
}
