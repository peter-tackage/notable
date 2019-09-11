import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:notable/arch/simple_bloc_delegate.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/data/provider.dart';
import 'package:notable/data/repository.dart';
import 'package:notable/entity/audio_note_entity.dart';
import 'package:notable/entity/audio_note_entity_mapper.dart';
import 'package:notable/entity/checklist_entity_mapper.dart';
import 'package:notable/entity/drawing_entity.dart';
import 'package:notable/entity/drawing_entity_mapper.dart';
import 'package:notable/entity/entity.dart';
import 'package:notable/entity/note_entity_mapper.dart';
import 'package:notable/l10n/localization.dart';
import 'package:notable/model/audio_note.dart';
import 'package:notable/model/audio_note_mapper.dart';
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
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(NotableApp());
}

class NotableApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<NotesBloc<TextNote, TextNoteEntity>>(
              builder: _textNoteBlocBuilder),
          BlocProvider<NotesBloc<Checklist, ChecklistEntity>>(
              builder: _checklistBlocBuilder),
          BlocProvider<NotesBloc<Drawing, DrawingEntity>>(
              builder: _drawingsBlocBuilder),
          BlocProvider<NotesBloc<AudioNote, AudioNoteEntity>>(
              builder: _audioNotesBlocBuilder)
        ],
        child: MaterialApp(
          title: 'Notable',
          localizationsDelegates: _localizationsDelegates(),
          supportedLocales: _supportedLocales(),
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: HomeScreen(title: 'Notable'),
        ));
  }

  //
  // Bloc Builders
  //

  NotesBloc<TextNote, TextNoteEntity> _textNoteBlocBuilder(
          BuildContext context) =>
      NotesBloc<TextNote, TextNoteEntity>(
          noteRepository: Repository<TextNoteEntity>(Provider<TextNoteEntity>(
              storage: FileStorage(
                  tag: "textNotes",
                  getDirectory: () => getApplicationDocumentsDirectory(),
                  entityMapper: NoteEntityMapper()))),
          mapper: TextNoteMapper());

  NotesBloc<Checklist, ChecklistEntity> _checklistBlocBuilder(
          BuildContext context) =>
      NotesBloc<Checklist, ChecklistEntity>(
          noteRepository: Repository<ChecklistEntity>(Provider<ChecklistEntity>(
              storage: FileStorage(
                  tag: "checklists",
                  getDirectory: () => getApplicationDocumentsDirectory(),
                  entityMapper: ChecklistEntityMapper()))),
          mapper: ChecklistMapper());

  NotesBloc<Drawing, DrawingEntity> _drawingsBlocBuilder(
          BuildContext context) =>
      NotesBloc<Drawing, DrawingEntity>(
          noteRepository: Repository<DrawingEntity>(Provider<DrawingEntity>(
              storage: FileStorage(
                  tag: "drawings",
                  getDirectory: () => getApplicationDocumentsDirectory(),
                  entityMapper: DrawingEntityMapper()))),
          mapper: DrawingMapper());

  NotesBloc<AudioNote, AudioNoteEntity> _audioNotesBlocBuilder(
          BuildContext context) =>
      NotesBloc<AudioNote, AudioNoteEntity>(
          noteRepository: Repository<AudioNoteEntity>(Provider<AudioNoteEntity>(
              storage: FileStorage(
                  tag: "audio",
                  getDirectory: () => getApplicationDocumentsDirectory(),
                  entityMapper: AudioNoteEntityMapper()))),
          mapper: AudioNoteMapper());

  //
  //  Localization
  //

  static List<Locale> _supportedLocales() {
    return [
      const Locale('en'),
      const Locale('es'),
    ];
  }

  static List<LocalizationsDelegate> _localizationsDelegates() {
    return [
      const NotableLocalizationsDelegate(),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ];
  }
}
