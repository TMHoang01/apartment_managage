part of 'feed_back_detail_bloc.dart';

sealed class FeedBackDetailState extends Equatable {
  FeedBackModel? feedBack;
  FeedBackDetailState({this.feedBack});

  @override
  List<Object> get props => [];
}

final class FeedBackDetailInitial extends FeedBackDetailState {}

final class FeedBackDetailLoading extends FeedBackDetailState {}

final class FeedBackDetailLoaded extends FeedBackDetailState {
  @override
  final FeedBackModel feedBack;
  FeedBackDetailLoaded({required this.feedBack});
  @override
  List<Object> get props => [feedBack];
}

final class FeedBackDetailUpdated extends FeedBackDetailLoaded {
  FeedBackDetailUpdated({required super.feedBack});
}

final class FeedBackDetailFailure extends FeedBackDetailState {
  final String message;
  FeedBackDetailFailure({super.feedBack, required this.message});

  @override
  List<Object> get props => [message];
}
