import 'dart:async';

import 'package:notable/entity/note_entity.dart';
import 'package:uuid/uuid.dart';

class NoteProvider {
  final Map<String, NoteEntity> _noteStore = Map();

  Future<List<NoteEntity>> getAllNotes() async {
    return _noteStore.values.toList();
  }

  Future<NoteEntity> getNote(String id) async {
    return _noteStore[id];
  }

  Future<NoteEntity> addNote(NoteEntity note) async {
    assert(note.id == null); // shouldn't already have an id

    String id = Uuid().v1().toString();
    return _noteStore.putIfAbsent(id, () => note.copyWith(id));
  }

  Future<NoteEntity> updateNote(NoteEntity note) async {
    assert(note.id != null); // must already have an id

    return _noteStore.update(note.id, (NoteEntity n) => note);
  }

  Future<NoteEntity> deleteNote(String id) async {
    return _noteStore.remove(id);
  }
}
