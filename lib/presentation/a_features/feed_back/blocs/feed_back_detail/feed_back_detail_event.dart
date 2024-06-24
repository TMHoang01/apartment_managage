part of 'feed_back_detail_bloc.dart';

sealed class FeedBackDetailEvent extends Equatable {
  const FeedBackDetailEvent();

  @override
  List<Object> get props => [];
}

class FeedBackDetailStarted extends FeedBackDetailEvent {
  final FeedBackModel feedBack;
  const FeedBackDetailStarted({required this.feedBack});

  @override
  List<Object> get props => [feedBack];
}

class FeedBackDetailChangeStatus extends FeedBackDetailEvent {
  // final String id;
  final FeedBackStatus status;
  const FeedBackDetailChangeStatus({required this.status});

  @override
  List<Object> get props => [status];
}

class FeedBackDetailUpdateSubmit extends FeedBackDetailEvent {
  final FeedBackModel fb;
  const FeedBackDetailUpdateSubmit(this.fb);

  @override
  List<Object> get props => [fb];
}
