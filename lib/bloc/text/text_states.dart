import 'package:equatable/equatable.dart';
import 'package:notable/model/text_note.dart';

abstract class TextNoteState extends Equatable {
  const TextNoteState();

  @override
  List<Object> get props => [];
}

class TextNoteLoading extends TextNoteState {}

class TextNoteLoaded extends TextNoteState {
  final TextNote textNote;

  const TextNoteLoaded(this.textNote);

  @override
  List<Object> get props => [textNote];

  @override
  String toString() => 'TextNoteLoaded { textNote: $textNote }';
}
