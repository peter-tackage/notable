import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/drawing.dart';
import 'package:notable/model/drawing_config.dart';

abstract class DrawingEvent extends Equatable {
  const DrawingEvent();

  @override
  List<Object> get props => [];
}

class LoadDrawing extends DrawingEvent {
  final Drawing drawing;

  const LoadDrawing(this.drawing);

  @override
  List<Object> get props => [drawing];

  @override
  String toString() => 'LoadDrawing: {id: ${drawing.id}}';
}

class SaveDrawing extends DrawingEvent { }

class DeleteDrawing extends DrawingEvent { }

class ClearDrawing extends DrawingEvent { }

class Undo extends DrawingEvent { }

class Redo extends DrawingEvent { }

class StartDrawing extends DrawingEvent {
  final DrawingConfig config;
  final OffsetValue offset;

  const StartDrawing(this.config, this.offset);

  @override
  List<Object> get props => [config, offset];

  @override
  String toString() => 'StartDrawing: $offset';
}

class UpdateDrawing extends DrawingEvent {
  final OffsetValue offset;

  const UpdateDrawing(this.offset);

  @override
  List<Object> get props => [offset];

  @override
  String toString() => 'UpdateDrawing: $offset';
}

class EndDrawing extends DrawingEvent { }

class UpdateDrawingTitle extends DrawingEvent {
  final String title;

  const UpdateDrawingTitle(this.title);

  @override
  List<Object> get props => [title];

  @override
  String toString() => 'UpdateDrawingTitle: $title';
}
