import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/checklist.dart';

@immutable
abstract class ChecklistState extends Equatable {
  ChecklistState([List props = const []]) : super(props);
}

@immutable
class ChecklistLoading extends ChecklistState {
  ChecklistLoading() : super([]);

  @override
  String toString() => 'ChecklistLoading';
}

@immutable
class ChecklistLoaded extends ChecklistState {
  final Checklist checklist;

  ChecklistLoaded(this.checklist) : super([checklist]);

  @override
  String toString() =>
      'ChecklistLoaded { checklist: ${checklist.items.length} }';
}
