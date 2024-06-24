part of 'posts_bloc.dart';

sealed class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object> get props => [];
}

class PostsStarted extends PostsEvent {
  final String? type;

  const PostsStarted({this.type});
}

class PostsLoadMoreStarted extends PostsEvent {}

// class PostsRefreshStarted extends PostsEvent {}

// class PostsDeleteStarted extends PostsEvent {
//   final String id;

//   const PostsDeleteStarted({required this.id});

//   @override
//   List<Object> get props => [id];
// }

class PostInsertStarted extends PostsEvent {
  final PostModel post;

  const PostInsertStarted({
    required this.post,
  });

  @override
  List<Object> get props => [post];
}

class PostsUpdateStarted extends PostsEvent {
  final PostModel post;

  const PostsUpdateStarted({
    required this.post,
  });

  @override
  List<Object> get props => [post];
}

class PostDeleteStarted extends PostsEvent {
  final PostModel post;

  const PostDeleteStarted({
    required this.post,
  });

  @override
  List<Object> get props => [post];
}
