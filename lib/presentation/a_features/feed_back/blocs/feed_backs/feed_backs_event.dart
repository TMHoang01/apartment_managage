part of 'feed_backs_bloc.dart';

sealed class FeedBacksEvent extends Equatable {
  const FeedBacksEvent();

  @override
  List<Object> get props => [];
}

class FeedBacksStarted extends FeedBacksEvent {}

class FeedBacksLoadMoreStarted extends FeedBacksEvent {}

class FeedBacksUpdateItem extends FeedBacksEvent {
  final FeedBackModel feedBack;
  const FeedBacksUpdateItem(this.feedBack);
}

class FeedBacksFilter extends FeedBacksEvent {
  final Map<String, String>? filter;

  const FeedBacksFilter({this.filter});
}
