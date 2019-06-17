import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/data/repository.dart';
import 'package:notable/entity/entity.dart';
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
    final title = "The note title";
    final text = "The note text";
    final uuid = Uuid().v1().toString();
    final datetime = DateTime.now();

    NoteEntity noteEntity = NoteEntity(List<LabelEntity>(), title, text,
        id: uuid, updatedDate: datetime);

    when(noteRepository.getAll()).thenAnswer((_) => Future.value([noteEntity]));

    textNoteBloc.dispatch(LoadNotes());

    Stream<NotesState> stateStream = textNoteBloc.state;

    Stream<String> test = Stream.fromIterable(["a", "b"]);

    expect(test, emitsInOrder([equals("a"), equals("bb")]));

//    expect(
//        stateStream,
//        emitsInOrder([
//          isA<NotesLoading>(),
//          isA<NotesLoaded>(),
//          equals(NotesLoaded([
//            TextNote(title, List<Label>(), text,
//                id: uuid, createdDate: datetime)
//          ]))
//        ]));
  });
}
