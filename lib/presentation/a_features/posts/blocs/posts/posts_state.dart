part of 'posts_bloc.dart';

sealed class PostsState extends Equatable {
  const PostsState();

  @override
  List<Object> get props => [];
}

final class PostsInitial extends PostsState {}

final class PostsLoadInProgress extends PostsState {}

final class PostsLoadSuccess extends PostsState {
  final List<PostModel> posts;

  const PostsLoadSuccess({required this.posts});

  @override
  List<Object> get props => [posts];
}

final class PostsLoadFailure extends PostsState {
  final String error;

  const PostsLoadFailure({required this.error});

  @override
  List<Object> get props => [error];
}

final class PostsModifyInProgress extends PostsState {}

final class PostsDeleteInProgress extends PostsState {}
