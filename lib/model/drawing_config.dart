import 'package:built_value/built_value.dart';
import 'package:meta/meta.dart';

part 'drawing_config.g.dart';

enum Tool { Brush, Eraser }
enum PenShape { Square, Round }

@immutable
abstract class DrawingConfig
    implements Built<DrawingConfig, DrawingConfigBuilder> {
  Tool get tool;

  PenShape get penShape;

  double get strokeWidth;

  int get color;

  int get alpha;

  DrawingConfig._();

  factory DrawingConfig([void Function(DrawingConfigBuilder) updates]) =
      _$DrawingConfig;
}
