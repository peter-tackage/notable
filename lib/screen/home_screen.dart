import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notable/bloc/feed/feed_bloc.dart';
import 'package:notable/bloc/feed/feed_events.dart';
import 'package:notable/screen/checklist_note_screen.dart';
import 'package:notable/screen/text_note_screen.dart';
import 'package:notable/widget/notes_page.dart';

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
              color: Colors.grey[200],
              child: ButtonBar(children: <Widget>[
                IconButton(
                    onPressed: () => _openTextNoteEditor(context),
                    icon: Icon(Icons.note_add)),
                IconButton(
                    onPressed: () => _openChecklistEditor(context),
                    icon: Icon(Icons.playlist_add))
              ]),
            ),
          ],
        ));
  }

  void _openChecklistEditor(BuildContext context) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddEditChecklistNoteScreen(id: null)));

  void _openTextNoteEditor(BuildContext context) => Navigator.push(context,
      MaterialPageRoute(builder: (context) => AddEditTextNoteScreen(id: null)));
}
