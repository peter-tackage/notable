import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:notable/bloc/notes/notes_events.dart';
import 'package:notable/bloc/notes/notes_states.dart';
import 'package:notable/data/repository.dart';
import 'package:notable/entity/note_entity.dart';
import 'package:notable/model/note.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final Repository<NoteEntity> noteRepository;

  NotesBloc({@required this.noteRepository});

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
      yield NotesLoaded(notes.map(Note.fromEntity).toList());
    }
  }

  Stream<NotesState> _mapAddNoteEventToState(
      NotesState currentState, NotesEvent event) async* {
    if (event is AddNote) {
      // Save the note and return all the notes
      await noteRepository.save(event.note.toEntity());
      List<NoteEntity> notes = await noteRepository.getAll();
      yield NotesLoaded(notes.map(Note.fromEntity).toList());
    }
  }

  Stream<NotesState> _mapUpdateNoteEventToState(
      NotesState currentState, NotesEvent event) async* {
    if (event is UpdateNote) {
      // Save the note and return all the notes
      await noteRepository.save(event.note.toEntity());
      List<NoteEntity> notes = await noteRepository.getAll();
      yield NotesLoaded(notes.map(Note.fromEntity).toList());
    }
  }

  Stream<NotesState> _mapDeleteNoteEventToState(
      NotesState currentState, NotesEvent event) async* {
    if (event is DeleteNote) {
      // Delete the note and return all the notes
      noteRepository.delete(event.id);

      final notes = await noteRepository.getAll();
      yield NotesLoaded(notes.map(Note.fromEntity).toList());
    }
  }
}
