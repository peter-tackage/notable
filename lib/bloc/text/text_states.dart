import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/text_note.dart';

@immutable
abstract class TextNoteState extends Equatable {
  TextNoteState([List props = const []]) : super(props);
}

@immutable
class TextNoteLoading extends TextNoteState {
  @override
  String toString() => 'TextNoteLoading';
}

@immutable
class TextNoteLoaded extends TextNoteState {
  final TextNote textNote;

  TextNoteLoaded(this.textNote) : super([textNote]);

  @override
  String toString() => 'TextNoteLoaded { textNote: $textNote }';
}
