import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:apartment_managage/domain/models/post/post.dart';
import 'package:apartment_managage/domain/repository/file_repository.dart';
import 'package:apartment_managage/domain/repository/post/post_repository.dart';
import 'package:apartment_managage/utils/utils.dart';

part 'post_form_event.dart';
part 'post_form_state.dart';

class PostFormBloc extends Bloc<PostFormEvent, PostFormState> {
  final PostRepository _postRepository;
  final FileRepository _fileRepository;

  PostFormBloc(
      {required PostRepository postRepository,
      required FileRepository fileRepository})
      : _fileRepository = fileRepository,
        _postRepository = postRepository,
        super(PostCreateInitial()) {
    on<PostFormEvent>((event, emit) {});
    on<PostFormCreateInit>(_onPostCreateInitType);
    on<PostFormCreateStart>(_onPostCreateStarted);
    on<PostFormCreateRetryStart>(_onPostCreateRetryStarted);

    on<PostFormEditInit>(_onPostEditInit);
    on<PostFormEditStart>(_onPostEditStarted);
  }

  void _onPostCreateInitType(
      PostFormCreateInit event, Emitter<PostFormState> emit) {
    emit(PostFormCreateStarting(type: event.type));
  }

  void _onPostEditInit(PostFormEditInit event, Emitter<PostFormState> emit) {
    emit(PostFormEditStarting(post: event.post));
  }

  void _onPostCreateStarted(
      PostFormCreateStart event, Emitter<PostFormState> emit) async {
    final post = (event.post.copyWith(
      createdAt: DateTime.now(),
      createdBy: userCurrent!.uid,
    ));
    try {
      emit(
        PostFormInProcess(post: post),
      );
      final imageUrl = await _uploadFile(
        imagePath: event.image,
      );

      final postSuccess = await _postRepository.add(
        post: post.copyWith(image: imageUrl, status: 'active'),
      );
      emit(PostFormCreateSuccess(post: postSuccess));
    } catch (e) {
      emit(PostFormFailure(
        post: post,
        error: e.toString(),
      ));
    }
  }

  void _onPostEditStarted(
      PostFormEditStart event, Emitter<PostFormState> emit) async {
    final post = (event.post.copyWith(
      updatedAt: DateTime.now(),
      updatedBy: userCurrent!.uid,
    ));
    try {
      emit(
        PostFormInProcess(post: post),
      );
      final imageUrl = await _uploadFile(
        imagePath: event.image,
        urlOld: post.image,
      );

      await _postRepository.update(post: post.copyWith(image: imageUrl));

      emit(PostFormEditSuccess(post: post.copyWith(image: imageUrl)));
    } catch (e) {
      emit(PostFormFailure(
        post: post,
        error: e.toString(),
      ));
    }
  }

  void _onPostCreateRetryStarted(
      PostFormCreateRetryStart event, Emitter<PostFormState> emit) async {
    PostModel post = PostModel(
      title: event.title,
      content: event.content,
      createdAt: DateTime.now(),
      createdBy: userCurrent!.uid,
    );
    try {
      emit(
        PostFormInProcess(
          post: post,
        ),
      );

      emit(PostFormCreateSuccess(post: post));
    } catch (e) {
      emit(PostFormFailure(
        post: post,
        error: e.toString(),
      ));
    }
  }

  Future<String?> _uploadFile(
      {required String imagePath, String? urlOld}) async {
    try {
      if (imagePath.isEmpty) return urlOld;
      File file = File(imagePath);
      String name = DateTime.now().millisecondsSinceEpoch.toString();
      name = '$name.${imagePath.split('.').last}';

      String imageUrl = await _fileRepository.uploadFile(
        file: file,
        path: 'images/posts/$name',
      );
      if (urlOld != null) {
        await _fileRepository.deleteFile(path: urlOld);
      }
      return imageUrl;
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }
}
