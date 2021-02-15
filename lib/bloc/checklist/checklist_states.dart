import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/checklist.dart';

@immutable
abstract class ChecklistState extends Equatable {
  const ChecklistState();

  @override
  List<Object> get props => [];
}

@immutable
class ChecklistLoading extends ChecklistState {}

@immutable
class ChecklistLoaded extends ChecklistState {
  final Checklist checklist;

  const ChecklistLoaded(this.checklist);

  @override
  List<Object> get props => [checklist];

  @override
  String toString() =>
      'ChecklistLoaded { checklist: ${checklist.items.length} }';
}
