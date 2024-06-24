import 'package:apartment_managage/domain/models/post/joiners.dart';
import 'package:apartment_managage/domain/models/post/post.dart';
import 'package:apartment_managage/utils/constants.dart';

abstract class PostRepository {
  // CRUD post
  Future<PostModel> add({required PostModel post});
  Future<void> update({required PostModel post});
  Future<void> delete({required String id});
  Future<List<PostModel>> getAll(
      {DateTime? lastCreateAt,
      int limit = LIMIT_PAGE,
      Map<String, String>? filter});
  Future<List<PostModel>> paginateQuey(
      {int limit = LIMIT_PAGE,
      String? query,
      String? type,
      DateTime? lastUpdate});

  Future<void> joinEvent({required String id, required JoinersModel joiner});
}
