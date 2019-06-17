import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/drawing.dart';
import 'package:notable/model/drawing_config.dart';

@immutable
abstract class DrawingEvent extends Equatable {
  DrawingEvent([List props = const []]) : super(props);
}

@immutable
class LoadDrawing extends DrawingEvent {
  final Drawing drawing;

  LoadDrawing(this.drawing) : super([drawing]);

  @override
  String toString() => 'LoadDrawing: {id: ${drawing.id}}';
}

@immutable
class SaveDrawing extends DrawingEvent {
  SaveDrawing() : super([]);

  @override
  String toString() => 'SaveDrawing';
}

@immutable
class DeleteDrawing extends DrawingEvent {
  DeleteDrawing() : super([]);

  @override
  String toString() => 'DeleteDrawing';
}

@immutable
class ClearDrawing extends DrawingEvent {
  ClearDrawing() : super([]);

  @override
  String toString() => 'ClearDrawing';
}

@immutable
class Undo extends DrawingEvent {
  Undo() : super([]);

  @override
  String toString() => 'UndoAction';
}

@immutable
class Redo extends DrawingEvent {
  Redo() : super([]);

  @override
  String toString() => 'RedoAction';
}

@immutable
class StartDrawing extends DrawingEvent {
  final DrawingConfig config;
  final OffsetValue offset;

  StartDrawing(this.config, this.offset) : super([config, offset]);

  @override
  String toString() => 'StartDrawing: $offset';
}

@immutable
class UpdateDrawing extends DrawingEvent {
  final OffsetValue offset;

  UpdateDrawing(this.offset) : super([offset]);

  @override
  String toString() => 'UpdateDrawing: $offset';
}

@immutable
class EndDrawing extends DrawingEvent {
  EndDrawing() : super([]);

  @override
  String toString() => 'EndDrawing';
}

@immutable
class UpdateDrawingTitle extends DrawingEvent {
  final String title;

  UpdateDrawingTitle(this.title) : super([title]);

  @override
  String toString() => 'UpdateDrawingTitle: $title';
}
