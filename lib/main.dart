import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notable/arch/simple_bloc_delegate.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/data/provider.dart';
import 'package:notable/data/repository.dart';
import 'package:notable/entity/entity.dart';
import 'package:notable/model/checklist.dart';
import 'package:notable/model/checklist_note_mapper.dart';
import 'package:notable/model/text_note.dart';
import 'package:notable/model/text_note_mapper.dart';
import 'package:notable/screen/home_screen.dart';

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(NotableApp());
}

class NotableApp extends StatelessWidget {
  final NotesBloc<TextNote, NoteEntity> _textNoteBloc =
      NotesBloc<TextNote, NoteEntity>(
          noteRepository: Repository<NoteEntity>(Provider<NoteEntity>()),
          mapper: TextNoteMapper());

  final NotesBloc<Checklist, ChecklistEntity> _checklistBloc =
      NotesBloc<Checklist, ChecklistEntity>(
          noteRepository:
              Repository<ChecklistEntity>(Provider<ChecklistEntity>()),
          mapper: ChecklistMapper());

  @override
  Widget build(BuildContext context) {
    return BlocProviderTree(
        blocProviders: [
          BlocProvider<NotesBloc<TextNote, NoteEntity>>(bloc: _textNoteBloc),
          BlocProvider<NotesBloc<Checklist, ChecklistEntity>>(
              bloc: _checklistBloc)
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
