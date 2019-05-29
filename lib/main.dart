import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notable/arch/simple_bloc_delegate.dart';
import 'package:notable/bloc/feed/feed_bloc.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/data/provider.dart';
import 'package:notable/data/repository.dart';
import 'package:notable/entity/checklist_entity_mapper.dart';
import 'package:notable/entity/drawing_entity.dart';
import 'package:notable/entity/drawing_entity_mapper.dart';
import 'package:notable/entity/entity.dart';
import 'package:notable/entity/note_entity_mapper.dart';
import 'package:notable/model/checklist.dart';
import 'package:notable/model/checklist_note_mapper.dart';
import 'package:notable/model/drawing.dart';
import 'package:notable/model/drawing_note_mapper.dart';
import 'package:notable/model/text_note.dart';
import 'package:notable/model/text_note_mapper.dart';
import 'package:notable/screen/home_screen.dart';
import 'package:notable/storage/file_storage.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(NotableApp());
}

class NotableApp extends StatelessWidget {
  final NotesBloc<TextNote, NoteEntity> _textNoteBloc =
      NotesBloc<TextNote, NoteEntity>(
          noteRepository: Repository<NoteEntity>(Provider<NoteEntity>(
              storage: FileStorage(
                  tag: "textNotes",
                  getDirectory: () => getApplicationDocumentsDirectory(),
                  entityMapper: NoteEntityMapper()))),
          mapper: TextNoteMapper());

  final NotesBloc<Checklist, ChecklistEntity> _checklistBloc =
      NotesBloc<Checklist, ChecklistEntity>(
          noteRepository: Repository<ChecklistEntity>(Provider<ChecklistEntity>(
              storage: FileStorage(
                  tag: "checklists",
                  getDirectory: () => getApplicationDocumentsDirectory(),
                  entityMapper: ChecklistEntityMapper()))),
          mapper: ChecklistMapper());

  final NotesBloc<Drawing, DrawingEntity> _drawingsBloc =
      NotesBloc<Drawing, DrawingEntity>(
          noteRepository: Repository<DrawingEntity>(Provider<DrawingEntity>(
              storage: FileStorage(
                  tag: "drawings",
                  getDirectory: () => getApplicationDocumentsDirectory(),
                  entityMapper: DrawingEntityMapper()))),
          mapper: DrawingMapper());

  @override
  Widget build(BuildContext context) {
    // FIXME  creation of the FeedBloc here like this could create new unwanted instances.
    // It should be outside the target widget (injected), but not where the
    // provider can be called multiple times with a new each time.
    return BlocProviderTree(
        blocProviders: [
          BlocProvider<NotesBloc<TextNote, NoteEntity>>(bloc: _textNoteBloc),
          BlocProvider<NotesBloc<Checklist, ChecklistEntity>>(
              bloc: _checklistBloc),
          BlocProvider<NotesBloc<Drawing, DrawingEntity>>(bloc: _drawingsBloc),
          BlocProvider<FeedBloc>(
              bloc: FeedBloc(
                  textNotesBloc: _textNoteBloc,
                  checklistNotesBloc: _checklistBloc,
                  drawingNotesBloc: _drawingsBloc))
        ],
        child: MaterialApp(
          title: 'Notable',
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: HomeScreen(title: 'Notable'),
        ));
  }
}
