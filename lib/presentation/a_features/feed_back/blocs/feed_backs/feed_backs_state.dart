part of 'feed_backs_bloc.dart';

sealed class FeedBacksState extends Equatable {
  final Map<String, String>? filter;
  const FeedBacksState({this.filter});

  @override
  List<Object> get props => [];
}

final class FeedBacksInitial extends FeedBacksState {}

final class FeedBacksLoading extends FeedBacksState {}

final class FeedBacksLoaded extends FeedBacksState {
  final List<FeedBackModel> feedBacks;
  const FeedBacksLoaded({required this.feedBacks, super.filter});

  @override
  List<Object> get props => [feedBacks];
}

final class FeedBacksFailure extends FeedBacksState {
  final String message;
  const FeedBacksFailure({required this.message});

  @override
  List<Object> get props => [message];
}

final class FeedBacksLoadingMore extends FeedBacksState {
  final List<FeedBackModel> oldPosts;
  const FeedBacksLoadingMore({required this.oldPosts, super.filter});

  @override
  List<Object> get props => [oldPosts];
}

final class FeedBacksLoadMoreFailure extends FeedBacksLoadingMore {
  final String message;

  FeedBacksLoadMoreFailure({required super.oldPosts, required this.message});

  @override
  List<Object> get props => [message];
}

final class FeedBacksLoadMoreEnd extends FeedBacksLoaded {
  const FeedBacksLoadMoreEnd({required super.feedBacks, super.filter});

  @override
  List<Object> get props => [];
}
