import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/base_note.dart';

abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object> get props => [];
}

class FeedLoading extends FeedState { }

class FeedLoaded extends FeedState {
  final List<BaseNote> feed;

  const FeedLoaded(this.feed);

  @override
  List<Object> get props => [feed];

  @override
  String toString() => 'FeedLoaded { feed: ${feed.length} }';
}
