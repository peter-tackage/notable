import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notable/arch/simple_bloc_delegate.dart';
import 'package:notable/bloc/notes/notes.dart';
import 'package:notable/data/note_provider.dart';
import 'package:notable/data/note_repository.dart';
import 'package:notable/screen/home_screen.dart';

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(NotableApp());
}

class NotableApp extends StatelessWidget {
  final NotesBloc _notesBloc =
      NotesBloc(noteRepository: NoteRepository(NoteProvider()));

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotesBloc>(
        bloc: _notesBloc,
        child: MaterialApp(
          title: 'Notable',
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: HomeScreen(
              title: 'Notable', onInit: () => _notesBloc.dispatch(LoadNotes())),
        ));
  }
}
