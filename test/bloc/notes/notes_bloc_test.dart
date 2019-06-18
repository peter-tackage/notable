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

class MockRepository extends Mock implements Repository<NoteEntity> {}

void main() {
  MockRepository noteRepository;
  NotesBloc<TextNote, NoteEntity> textNoteBloc =
      NotesBloc<TextNote, NoteEntity>(
          noteRepository: noteRepository, mapper: TextNoteMapper());

  setUp(() {
    // No point in mocking the Mapper
    noteRepository = MockRepository();
    textNoteBloc = NotesBloc<TextNote, NoteEntity>(
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

  test('LoadNotes triggers NotesLoading, NotesLoaded', () {
    // given
    final title = "The note title";
    final text = "The note text";
    final uuid = Uuid().v1().toString();
    final datetime = DateTime.now();

    NoteEntity noteEntity = NoteEntity(List<LabelEntity>(), title, text,
        id: uuid, updatedDate: datetime);
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
              ..id = uuid
              ..updatedDate = datetime)
          ]))
        ]));
  });
}
