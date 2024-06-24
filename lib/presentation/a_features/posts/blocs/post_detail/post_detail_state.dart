part of 'post_detail_bloc.dart';

sealed class PostDetailState extends Equatable {
  const PostDetailState();

  @override
  List<Object> get props => [];
}

final class PostDetailInitial extends PostDetailState {}

final class PostDetailLoadInProgress extends PostDetailState {}

final class PostDetailLoadSuccess extends PostDetailState {
  final PostModel post;

  const PostDetailLoadSuccess({required this.post});

  @override
  List<Object> get props => [post];
}

final class PostDetailLoadFailure extends PostDetailState {
  final String error;

  const PostDetailLoadFailure({required this.error});

  @override
  List<Object> get props => [error];
}

final class PostDetailDeleteSuccess extends PostDetailState {}
