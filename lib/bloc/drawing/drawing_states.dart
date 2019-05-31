import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/drawing.dart';

@immutable
abstract class DrawingState extends Equatable {
  DrawingState([List props = const []]) : super(props);
}

@immutable
class DrawingLoading extends DrawingState {
  DrawingLoading() : super([]);

  @override
  String toString() => 'DrawingLoading';
}

@immutable
class DrawingLoaded extends DrawingState {
  final Drawing drawing;

  DrawingLoaded({@required this.drawing}) : super([drawing]);

  @override
  String toString() => 'DrawingLoaded { id: ${drawing.id} }';
}

