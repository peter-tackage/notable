import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/drawing.dart';

@immutable
abstract class DrawingState extends Equatable {
  const DrawingState();

  @override
  List<Object> get props => [];
}

@immutable
class DrawingLoading extends DrawingState { }

@immutable
class DrawingLoaded extends DrawingState {
  final Drawing drawing;

  const DrawingLoaded({@required this.drawing});

  @override
  List<Object> get props => [drawing];

  @override
  String toString() => 'DrawingLoaded { id: ${drawing.id} }';
}

