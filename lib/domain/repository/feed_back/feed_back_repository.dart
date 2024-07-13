import 'dart:async';

import 'package:apartment_managage/domain/models/feed_back/feed_back.dart';
import 'package:apartment_managage/utils/constants.dart';

export 'package:apartment_managage/data/repository/feed_back/feed_back_repository.dart';

abstract class FeedBackRepository {
  Future<FeedBackModel?> add({required FeedBackModel feedBack});
  Future<FeedBackModel?> getById({required String id});
  Future<void> update({required FeedBackModel feedBack});
  Future<void> delete({required String id});
  Future<List<FeedBackModel>> getAll(
      {DateTime? lastCreateAt,
      int limit = LIMIT_PAGE,
      Map<String, String>? filter});
  Future<List<FeedBackModel>> getFeedback(
      {DateTime? lastCreatedAt,
      int limit = LIMIT_PAGE,
      Map<String, String>? filter});

  // load more

  Stream<List<FeedBackModel>> getAllByUserId({required String userId});

  Future<void> changeStatus({String? id, required FeedBackStatus status});

  Future<void> dispose();
}
