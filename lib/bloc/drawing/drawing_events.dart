import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/drawing.dart';
import 'package:notable/model/drawing_config.dart';

@immutable
abstract class DrawingEvent extends Equatable {
  const DrawingEvent();

  @override
  List<Object> get props => [];
}

@immutable
class LoadDrawing extends DrawingEvent {
  final Drawing drawing;

  const LoadDrawing(this.drawing);

  @override
  List<Object> get props => [drawing];

  @override
  String toString() => 'LoadDrawing: {id: ${drawing.id}}';
}

@immutable
class SaveDrawing extends DrawingEvent { }

@immutable
class DeleteDrawing extends DrawingEvent { }

@immutable
class ClearDrawing extends DrawingEvent { }

@immutable
class Undo extends DrawingEvent { }

@immutable
class Redo extends DrawingEvent { }

@immutable
class StartDrawing extends DrawingEvent {
  final DrawingConfig config;
  final OffsetValue offset;

  const StartDrawing(this.config, this.offset);

  @override
  List<Object> get props => [config, offset];

  @override
  String toString() => 'StartDrawing: $offset';
}

@immutable
class UpdateDrawing extends DrawingEvent {
  final OffsetValue offset;

  const UpdateDrawing(this.offset);

  @override
  List<Object> get props => [offset];

  @override
  String toString() => 'UpdateDrawing: $offset';
}

@immutable
class EndDrawing extends DrawingEvent { }

@immutable
class UpdateDrawingTitle extends DrawingEvent {
  final String title;

  const UpdateDrawingTitle(this.title);

  @override
  List<Object> get props => [title];

  @override
  String toString() => 'UpdateDrawingTitle: $title';
}
