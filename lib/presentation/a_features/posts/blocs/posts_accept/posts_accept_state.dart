part of 'posts_accept_bloc.dart';

sealed class PostsAcceptState extends Equatable {
  const PostsAcceptState();

  @override
  List<Object> get props => [];
}

final class PostsAcceptInitial extends PostsAcceptState {}

final class PostsAcceptLoading extends PostsAcceptState {}

final class PostsAcceptLoaded extends PostsAcceptState {
  final List<PostModel> list;

  PostsAcceptLoaded({required this.list});

  @override
  List<Object> get props => [...list];
}

final class PostsAcceptError extends PostsAcceptState {
  final List<PostModel>? list;
  final String error;

  const PostsAcceptError({this.list, required this.error});
}
