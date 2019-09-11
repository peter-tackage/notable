import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:notable/entity/entity.dart';

void main() {
  test('note entity serializes', () {
    final now = DateTime.now();
    TextNoteEntity noteEntity = TextNoteEntity(
        <LabelEntity>[LabelEntity("label1", "blue")], "a title", "some text",
        id: "uuid-field", updatedDate: now);

    final json = jsonEncode(noteEntity);

    expect(json,
        "{\"id\":\"uuid-field\",\"updatedDate\":\"${now.toIso8601String()}\",\"title\":\"a title\",\"labels\":[{\"name\":\"label1\",\"color\":\"blue\"}],\"text\":\"some text\"}");
  });

  test('note entity list serializes', () {
    final now = DateTime.now();
    TextNoteEntity noteEntity1 = TextNoteEntity(
        <LabelEntity>[], "a title", "some text",
        id: "uuid-field", updatedDate: now);

    List<TextNoteEntity> noteEntities = [noteEntity1];

    final json = jsonEncode(noteEntities);

    expect(json,
        "[{\"id\":\"uuid-field\",\"updatedDate\":\"${now.toIso8601String()}\",\"title\":\"a title\",\"labels\":[],\"text\":\"some text\"}]");
  });

  test('note entity deserializes', () {
    final now = DateTime.now();

    String jsonString =
        "{\"id\":\"uuidValue\",\"updatedDate\":\"${now.toIso8601String()}\",\"title\":\"a title\",\"labels\":[{\"name\":\"label1\",\"color\":\"blue\"}],\"text\":\"some text\"}";
    final json = jsonDecode(jsonString);

    TextNoteEntity noteEntity = TextNoteEntity.fromJson(json);

    expect(noteEntity.id, "uuidValue");
  });
}
