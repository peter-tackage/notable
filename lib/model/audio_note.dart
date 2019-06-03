import 'package:meta/meta.dart';
import 'package:notable/model/base_note.dart';

@immutable
class AudioNote extends BaseNote {
  final String filename;

  AudioNote(title, labels, this.filename, {id, createdDate})
      : super(title, labels, id: id, updatedDate: createdDate);

  @override
  String toString() => 'AudioNote: $title';

  AudioNote copyWith(String title, String filename) =>
      AudioNote(title, this.labels, filename,
          id: this.id, createdDate: this.updatedDate);
}
