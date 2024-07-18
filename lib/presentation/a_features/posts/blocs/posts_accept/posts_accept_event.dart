part of 'posts_accept_bloc.dart';

sealed class PostsAcceptEvent extends Equatable {
  const PostsAcceptEvent();

  @override
  List<Object> get props => [];
}

class PostsAcceptStarted extends PostsAcceptEvent {}

class PostsAcceptChangeStatus extends PostsAcceptEvent {
  final PostModel? post;
  final String status;
  const PostsAcceptChangeStatus(this.post, this.status);
}
