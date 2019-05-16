import 'package:notable/entity/base_note_entity.dart';

class NoteEntity extends BaseNoteEntity {
  final String text;

  NoteEntity(labels, title, this.text, {id, updatedDate})
      : super(title, labels, id: id, updatedDate: updatedDate);
}
