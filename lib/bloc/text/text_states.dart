import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/text_note.dart';

@immutable
abstract class TextNoteState extends Equatable {
  const TextNoteState();

  @override
  List<Object> get props => [];
}

@immutable
class TextNoteLoading extends TextNoteState { }

@immutable
class TextNoteLoaded extends TextNoteState {
  final TextNote textNote;

  const TextNoteLoaded(this.textNote);

  @override
  List<Object> get props => [textNote];

  @override
  String toString() => 'TextNoteLoaded { textNote: $textNote }';
}
