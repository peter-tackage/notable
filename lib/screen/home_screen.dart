import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notable/bloc/feed/feed_bloc.dart';
import 'package:notable/bloc/feed/feed_events.dart';
import 'package:notable/screen/addedit_audio_note_screen.dart';
import 'package:notable/screen/addedit_checklist_note_screen.dart';
import 'package:notable/screen/addedit_drawing_note_screen.dart';
import 'package:notable/screen/addedit_text_note_screen.dart';
import 'package:notable/widget/all_notes_page.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FeedBloc _feedBloc;

  @override
  void initState() {
    super.initState();
    _feedBloc = BlocProvider.of<FeedBloc>(context);
    _feedBloc.dispatch(LoadFeed()); // FIXME Should be moved out
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: BlocProvider<FeedBloc>(
              bloc: _feedBloc,
              child: AllNotesPage(),
            )),
            Container(
                height: 64,
                child: Material(
                  color: Colors.grey[200],
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                            child: IconButton(
                                tooltip: "Create audio clip",
                                onPressed: () => _openAudioNoteEditor(context),
                                icon: Icon(Icons.mic))),
                        InkWell(
                            child: IconButton(
                                tooltip: "Create drawing",
                                onPressed: () =>
                                    _openDrawingNoteEditor(context),
                                icon: Icon(Icons.brush))),
                        InkWell(
                            child: IconButton(
                                tooltip: "Create note",
                                onPressed: () => _openTextNoteEditor(context),
                                icon: Icon(Icons.format_quote))),
                        InkWell(
                            child: IconButton(
                                tooltip: "Create checklist",
                                onPressed: () => _openChecklistEditor(context),
                                icon: Icon(Icons.format_list_bulleted)))
                      ]),
                )),
          ],
        ));
  }

  void _openChecklistEditor(BuildContext context) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddEditChecklistNoteScreen(id: null)));

  void _openTextNoteEditor(BuildContext context) => Navigator.push(context,
      MaterialPageRoute(builder: (context) => AddEditTextNoteScreen(id: null)));

  void _openDrawingNoteEditor(BuildContext context) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddEditDrawingNoteScreen(id: null)));

  void _openAudioNoteEditor(BuildContext context) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddEditAudioNoteScreen(id: null)));
}
