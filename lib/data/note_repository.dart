import 'package:notable/data/note_provider.dart';
import 'package:notable/entity/note_entity.dart';

class NoteRepository {
  final NoteProvider _noteProvider;

  NoteRepository(this._noteProvider);

  Future<List<NoteEntity>> getAllNotes() async {
    return _noteProvider.getAllNotes();
  }

  Future<NoteEntity> getNote(String id) async {
    return _noteProvider.getNote(id);
  }

  Future<NoteEntity> addNote(NoteEntity note) async {
    return _noteProvider.addNote(note);
  }

  Future<NoteEntity> updateNote(NoteEntity note) async {
    return _noteProvider.updateNote(note);
  }

  Future<NoteEntity> deleteNote(String id) async {
    return _noteProvider.deleteNote(id);
  }
}
