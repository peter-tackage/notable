import 'package:built_collection/built_collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/data/repository.dart';
import 'package:notable/entity/entity.dart';
import 'package:notable/model/label.dart';
import 'package:notable/model/text_note.dart';
import 'package:notable/model/text_note_mapper.dart';
import 'package:uuid/uuid.dart';

class MockRepository extends Mock implements Repository<TextNoteEntity> {}

void main() {
  MockRepository noteRepository;
  NotesBloc<TextNote, TextNoteEntity> textNoteBloc =
      NotesBloc<TextNote, TextNoteEntity>(
          noteRepository: noteRepository, mapper: TextNoteMapper());

  setUp(() {
    // No value in mocking the Mapper, use the real one.
    noteRepository = MockRepository();
    textNoteBloc = NotesBloc<TextNote, TextNoteEntity>(
        noteRepository: noteRepository, mapper: TextNoteMapper());
  });

  test('initial state is NoteLoading', () {
    Stream<NotesState> stateStream = textNoteBloc.state;

    expect(
        stateStream,
        emitsInOrder([
          isA<NotesLoading>(),
        ]));
  });

  test('LoadNotes triggers NotesLoading, NotesLoaded with value', () {
    // given
    final title = "The note title";
    final text = "The note text";
    final id = Uuid().v1().toString();
    final datetime = DateTime.now();

    TextNoteEntity noteEntity = TextNoteEntity(List<LabelEntity>(), title, text,
        id: id, updatedDate: datetime);
    when(noteRepository.getAll()).thenAnswer((_) => Future.value([noteEntity]));

    // when
    textNoteBloc.dispatch(LoadNotes());

    // then
    expect(
        textNoteBloc.state,
        emitsInOrder([
          isA<NotesLoading>(),
          equals(NotesLoaded([
            TextNote((b) => b
              ..title = title
              ..labels = ListBuilder<Label>()
              ..text = text
              ..id = id
              ..updatedDate = datetime)
          ]))
        ]));
  });

  test('AddNote triggers NotesLoading, NotesLoaded with value', () {
    // given

    // This will be the returned "saved" entity from the repository
    final title = "The note title";
    final text = "The note text";

    // These properties are actually defined by the (real) repository.
    final id = Uuid().v1().toString();
    final datetime = DateTime.now();

    TextNoteEntity noteEntity = TextNoteEntity(List<LabelEntity>(), title, text,
        id: id, updatedDate: datetime);
    when(noteRepository.getAll()).thenAnswer((_) => Future.value([noteEntity]));

    TextNote textNote = TextNote((b) => b
      ..title = title
      ..text = text);

    // when
    textNoteBloc.dispatch(AddNote(textNote));

    // then
    expect(
        textNoteBloc.state,
        emitsInOrder([
          isA<NotesLoading>(),
          equals(NotesLoaded([
            TextNote((b) => b
              ..title = title
              ..labels = ListBuilder<Label>()
              ..text = text
              ..id = id
              ..updatedDate = datetime)
          ]))
        ]));
  });
}
