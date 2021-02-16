import 'package:equatable/equatable.dart';
import 'package:notable/model/drawing_config.dart';

abstract class DrawingConfigState extends Equatable {
  const DrawingConfigState();

  @override
  List<Object> get props => [];
}

class DrawingConfigLoaded extends DrawingConfigState {
  final DrawingConfig drawingConfig;

  const DrawingConfigLoaded(this.drawingConfig);

  @override
  List<Object> get props => [drawingConfig];

  @override
  String toString() => 'DrawingConfigLoaded: { drawingConfig: $drawingConfig }';
}
