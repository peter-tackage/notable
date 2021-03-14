import 'package:equatable/equatable.dart';
import 'package:notable/model/checklist.dart';

abstract class ChecklistState extends Equatable {
  const ChecklistState();

  @override
  List<Object> get props => [];
}

class ChecklistLoading extends ChecklistState {}

class ChecklistLoaded extends ChecklistState {
  final Checklist checklist;

  const ChecklistLoaded(this.checklist);

  @override
  List<Object> get props => [checklist];

  @override
  String toString() =>
      'ChecklistLoaded { checklist: ${checklist.items.length} }';
}
