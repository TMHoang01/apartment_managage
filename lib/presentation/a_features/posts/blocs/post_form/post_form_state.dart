part of 'post_form_bloc.dart';

sealed class PostFormState extends Equatable {
  const PostFormState();

  @override
  List<Object> get props => [];
}

final class PostCreateInitial extends PostFormState {}

final class PostFormCreateStarting extends PostFormState {
  final PostType type;
  const PostFormCreateStarting({required this.type});
}

final class PostFormInProcess extends PostFormState {
  final PostModel post;

  const PostFormInProcess({required this.post});

  @override
  List<Object> get props => [post];
}

final class PostFormCreateSuccess extends PostFormState {
  final PostModel post;
  const PostFormCreateSuccess({required this.post});

  @override
  List<Object> get props => [post];
}

final class PostFormFailure extends PostFormState {
  final PostModel post;
  final String error;
  const PostFormFailure({required this.post, required this.error});

  @override
  List<Object> get props => [post, error];
}

final class PostFormEditStarting extends PostFormState {
  final PostModel post;
  const PostFormEditStarting({required this.post});
}

final class PostFormEditSuccess extends PostFormState {
  final PostModel post;
  const PostFormEditSuccess({required this.post});

  @override
  List<Object> get props => [post];
}

final class PostEditFailure extends PostFormState {
  final PostModel post;
  final String error;
  const PostEditFailure({required this.post, required this.error});

  @override
  List<Object> get props => [post, error];
}
