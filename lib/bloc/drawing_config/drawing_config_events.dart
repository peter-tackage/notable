import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DrawingConfigEvent extends Equatable {
  DrawingConfigEvent([List props = const []]) : super(props);
}

@immutable
class LoadDrawingConfig extends DrawingConfigEvent {
  LoadDrawingConfig() : super([]);

  @override
  String toString() => 'LoadDrawingConfig';
}
