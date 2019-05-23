import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notable/model/base_note.dart';

@immutable
abstract class FeedState extends Equatable {
  FeedState([List props = const []]) : super(props);
}

@immutable
class FeedLoading extends FeedState {
  FeedLoading() : super([]);

  @override
  String toString() => 'FeedLoading';
}

@immutable
class FeedLoaded extends FeedState {
  final List<BaseNote> feed;

  FeedLoaded(this.feed) : super([feed]);

  @override
  String toString() => 'FeedLoaded { feed: ${feed.length} }';
}
