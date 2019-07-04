import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:notable/bloc/notes/notes_events.dart';
import 'package:notable/bloc/notes/notes_states.dart';
import 'package:notable/data/mapper.dart';
import 'package:notable/data/repository.dart';
import 'package:notable/entity/base_note_entity.dart';
import 'package:notable/model/base_note.dart';

class NotesBloc<M extends BaseNote, E extends BaseNoteEntity>
    extends Bloc<NotesEvent, NotesState> {
  final Repository<BaseNoteEntity> noteRepository;
  final Mapper<M, E> mapper;

  NotesBloc({@required this.noteRepository, @required this.mapper});

  @override
  NotesState get initialState => NotesLoading();

  @override
  Stream<NotesState> mapEventToState(NotesEvent event) async* {
    if (event is LoadNotes) {
      yield* _mapLoadNotesEventToState(currentState, event);
    } else if (event is DeleteNote) {
      yield* _mapDeleteNoteEventToState(currentState, event);
    } else if (event is AddNote) {
      yield* _mapAddNoteEventToState(currentState, event);
    } else if (event is UpdateNote) {
      yield* _mapUpdateNoteEventToState(currentState, event);
    }
  }

  Stream<NotesState> _mapLoadNotesEventToState(
      NotesState currentState, NotesEvent event) async* {
    if (event is LoadNotes) {
      yield NotesLoading();

      final notes = await noteRepository.getAll();
      yield NotesLoaded(_toModels(notes));
    }
  }

  Stream<NotesState> _mapAddNoteEventToState(
      NotesState currentState, NotesEvent event) async* {
    if (event is AddNote) {
      // Save the note and return all the notes
      await noteRepository.save(mapper.toEntity(event.note));
      final notes = await noteRepository.getAll();
      yield NotesLoaded(_toModels(notes));
    }
  }

  Stream<NotesState> _mapUpdateNoteEventToState(
      NotesState currentState, NotesEvent event) async* {
    if (event is UpdateNote) {
      // Save the note and return all the notes
      await noteRepository.save(mapper.toEntity(event.note));
      final notes = await noteRepository.getAll();
      yield NotesLoaded(_toModels(notes));
    }
  }

  Stream<NotesState> _mapDeleteNoteEventToState(
      NotesState currentState, NotesEvent event) async* {
    if (event is DeleteNote) {
      // Delete the note and return all the notes
      await noteRepository.delete(event.id);

      final notes = await noteRepository.getAll();
      yield NotesLoaded(_toModels(notes));
    }
  }

  List _toModels(List<BaseNoteEntity> notes) =>
      notes.map((e) => mapper.toModel(e)).toList();
}
