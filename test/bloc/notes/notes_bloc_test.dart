import 'package:bloc_test/bloc_test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:mockito/mockito.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/data/repository.dart';
import 'package:notable/entity/entity.dart';
import 'package:notable/model/label.dart';
import 'package:notable/model/text_note.dart';
import 'package:notable/model/text_note_mapper.dart';
import 'package:test/test.dart';

class MockRepository extends Mock implements Repository<TextNoteEntity> {}

void main() {
  final _dateNow = DateTime.now();

  test('initial state is NoteLoading', () {
    final textNoteBloc = NotesBloc<TextNote, TextNoteEntity>(
        noteRepository: MockRepository(), mapper: TextNoteMapper());
    expect(textNoteBloc.state, isA<NotesLoading>());
  });

  // test('initial state is NoteLoading', () {
  //
  //   noteRepository = MockRepository();

  blocTest<NotesBloc<TextNote, TextNoteEntity>, NotesState>(
    'emits [NotesLoading] on LoadNotes',
    build: () => NotesBloc<TextNote, TextNoteEntity>(
        noteRepository: MockRepository(), mapper: TextNoteMapper()),
    act: (a) => {a.add(LoadNotes())},
    expect: [NotesLoading()],
  );

  blocTest<NotesBloc<TextNote, TextNoteEntity>, NotesState>(
    'emits nothing when no action',
    build: () => NotesBloc<TextNote, TextNoteEntity>(
        noteRepository: MockRepository(), mapper: TextNoteMapper()),
    act: (a) => {},
    expect: [],
  );

  blocTest<NotesBloc<TextNote, TextNoteEntity>, NotesState>(
    'Load [NotesLoading] on LoadNotes',
    build: () {
      final title = 'The note title';
      final text = 'The note text';
      final id = 'the id';
      final datetime = _dateNow;
      var noteEntity = TextNoteEntity(<LabelEntity>[], title, text,
          id: id, updatedDate: datetime);

      final noteRepository = MockRepository();
      when(noteRepository.getAll())
          .thenAnswer((_) => Future.value([noteEntity]));

      return NotesBloc<TextNote, TextNoteEntity>(
          noteRepository: noteRepository, mapper: TextNoteMapper());
    },
    act: (a) => {a.add(LoadNotes())},
    expect: [
      NotesLoading(),
      NotesLoaded([
        TextNote((b) => b
          ..title = 'The note title'
          ..labels = ListBuilder<Label>()
          ..text = 'The note text'
          ..id = 'the id'
          ..updatedDate = _dateNow)
      ])
    ],
  );

  // test('AddNote triggers NotesLoading, NotesLoaded with value', () {
  //   // given
  //   // This will be the returned "saved" entity from the repository
  //   final title = 'The note title';
  //   final text = 'The note text';
  //
  //   // These properties are actually defined by the (real) repository.
  //   final id = Uuid().v1().toString();
  //   final datetime = DateTime.now();
  //
  //   var noteEntity = TextNoteEntity(<LabelEntity>[], title, text,
  //       id: id, updatedDate: datetime);
  //   when(noteRepository.getAll()).thenAnswer((_) => Future.value([noteEntity]));
  //
  //   var textNote = TextNote((b) => b
  //     ..title = title
  //     ..text = text);
  //
  //   // when
  //   textNoteBloc.add(AddNote(textNote));
  //
  //   // then
  //   expect(
  //       textNoteBloc.state,
  //       emitsInOrder([
  //         isA<NotesLoading>(),
  //         equals(NotesLoaded([
  //           TextNote((b) => b
  //             ..title = title
  //             ..labels = ListBuilder<Label>()
  //             ..text = text
  //             ..id = id
  //             ..updatedDate = datetime)
  //         ]))
  //       ]));
  // });
}
