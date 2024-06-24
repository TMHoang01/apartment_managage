part of 'post_form_bloc.dart';

sealed class PostFormEvent extends Equatable {
  const PostFormEvent();

  @override
  List<Object> get props => [];
}

class PostFormCreateInit extends PostFormEvent {
  final PostType type;

  const PostFormCreateInit(this.type);
}

class PostFormCreateStart extends PostFormEvent {
  final PostModel post;
  final String image;

  const PostFormCreateStart({
    required this.post,
    required this.image,
  });

  @override
  List<Object> get props => [post, image];
}

class PostFormCreateRetryStart extends PostFormEvent {
  final String imagePath;
  final String title;
  final String content;

  const PostFormCreateRetryStart({
    required this.imagePath,
    required this.title,
    required this.content,
  });

  @override
  List<Object> get props => [title, content, imagePath];
}

class PostFormEditInit extends PostFormEvent {
  final PostModel post;

  const PostFormEditInit(this.post);
}

class PostFormEditStart extends PostFormEvent {
  final PostModel post;
  final String image;

  const PostFormEditStart({
    required this.post,
    required this.image,
  });

  @override
  List<Object> get props => [post, image];
}
