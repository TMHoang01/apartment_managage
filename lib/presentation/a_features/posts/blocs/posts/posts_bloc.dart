import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:apartment_managage/domain/models/post/post.dart';
import 'package:apartment_managage/domain/repository/post/post_repository.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostRepository _postRepository;
  PostsBloc(this._postRepository) : super(PostsInitial()) {
    on<PostsEvent>((event, emit) {});
    on<PostsStarted>(_onPostsStarted);
    on<PostInsertStarted>(_onPostInsertStarted);
    on<PostsUpdateStarted>(_onPostUpdateStarted);
    on<PostDeleteStarted>(_onPostDeleteStarted);
    on<PostsLoadMoreStarted>(_onPostsLoadMoreStarted);
  }
  List<PostModel> list = [];
  Map<String, String>? filter;
  bool isLoadMore = false;
  bool isLoadMoreEnd = false;

  void _onPostsStarted(PostsStarted event, Emitter<PostsState> emit) async {
    emit(PostsLoadInProgress());
    try {
      Map<String, String>? filter;
      if (event.type != null) {
        filter = {
          'type': event.type!,
        };
      }
      final posts = await _postRepository.getAll(filter: filter);
      emit(PostsLoadSuccess(posts: posts));
    } catch (e) {
      emit(PostsLoadFailure(error: e.toString()));
    }
  }

  void _onPostsLoadMoreStarted(
      PostsLoadMoreStarted event, Emitter<PostsState> emit) async {
    if (isLoadMoreEnd) return;
    if (state is PostsLoadInProgress) return;
    if (state is PostsLoadSuccess || state is PostsLoadFailure) {
      try {
        final lastCreateAt = list.last.createdAt;
        final posts = await _postRepository.getAll(
          lastCreateAt: lastCreateAt,
          filter: filter,
        );
        if (posts.isEmpty) {
          // emit(PostsLoadMoreEnd());
        } else {
          list.addAll(posts);
          if (posts.length < 10) {
            isLoadMoreEnd = true;
          }

          emit(PostsLoadSuccess(posts: list));
        }
      } catch (e) {
        emit(PostsLoadFailure(error: e.toString()));
      }
    }
  }

  void _onPostInsertStarted(
      PostInsertStarted event, Emitter<PostsState> emit) async {
    final post = event.post;
    try {
      final posts = (state as PostsLoadSuccess).posts;
      emit(
        PostsModifyInProgress(),
      );

      posts.insert(0, post);
      emit(PostsLoadSuccess(posts: posts));
    } catch (e) {
      emit(PostsLoadFailure(error: e.toString()));
    }
  }

  void _onPostUpdateStarted(
      PostsUpdateStarted event, Emitter<PostsState> emit) async {
    final post = event.post;
    try {
      final posts = (state as PostsLoadSuccess).posts;
      emit(
        PostsModifyInProgress(),
      );

      final index = posts.indexWhere((element) => element.id == post.id);
      posts[index] = post;
      emit(PostsLoadSuccess(posts: posts));
    } catch (e) {
      emit(PostsLoadFailure(error: e.toString()));
    }
  }

  void _onPostDeleteStarted(
      PostDeleteStarted event, Emitter<PostsState> emit) async {
    final id = event.post.id;
    try {
      final image = event.post.image;
      final posts = (state as PostsLoadSuccess).posts;
      emit(
        PostsDeleteInProgress(),
      );

      posts.removeWhere((element) => element.id == id);
      emit(PostsLoadSuccess(posts: posts));
    } catch (e) {
      emit(PostsLoadFailure(error: e.toString()));
    }
  }
}
