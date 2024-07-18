import 'package:apartment_managage/domain/models/post/post.dart';
import 'package:apartment_managage/domain/repository/post/post_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'posts_accept_event.dart';
part 'posts_accept_state.dart';

class PostsAcceptBloc extends Bloc<PostsAcceptEvent, PostsAcceptState> {
  final PostRepository _postRepository;

  PostsAcceptBloc(this._postRepository) : super(PostsAcceptInitial()) {
    on<PostsAcceptEvent>((event, emit) {});
    on<PostsAcceptStarted>(_onPostsStarted);
    on<PostsAcceptChangeStatus>(_onPostsChangeStatus);
  }

  void _onPostsStarted(
      PostsAcceptStarted event, Emitter<PostsAcceptState> emit) async {
    emit(PostsAcceptLoading());
    try {
      // Map<String, String>? filter;
      // if (event.type != null) {
      //   filter = {
      //     'type': event.type!,
      //   };
      // }
      final posts = await _postRepository.getPendingPosts();
      emit(PostsAcceptLoaded(list: posts));
    } catch (e) {
      emit(PostsAcceptError(error: e.toString()));
    }
  }

  void _onPostsChangeStatus(
      PostsAcceptChangeStatus event, Emitter<PostsAcceptState> emit) async {
    try {
      final post = event.post?.copyWith(
            status: event.status,
          ) ??
          PostModel();
      await _postRepository.update(post: post);

      if (state is PostsAcceptLoaded) {
        var list = List<PostModel>.from((state as PostsAcceptLoaded).list);
        emit(PostsAcceptLoading());

        emit(PostsAcceptLoaded(list: list));
      }
    } catch (e) {
      emit(PostsAcceptError(error: e.toString()));
    }
  }
}
