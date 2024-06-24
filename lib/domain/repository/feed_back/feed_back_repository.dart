import 'dart:async';

import 'package:apartment_managage/data/datasources/feed_back/feed_back_remote.dart';
import 'package:apartment_managage/domain/models/feed_back/feed_back.dart';
import 'package:apartment_managage/utils/constants.dart';
import 'package:apartment_managage/utils/logger.dart';

abstract class FeedBackRepository {
  Future<FeedBackModel?> add({required FeedBackModel feedBack});
  Future<FeedBackModel?> getById({required String id});
  Future<void> update({required FeedBackModel feedBack});
  Future<void> delete({required String id});
  Future<List<FeedBackModel>> getAll(
      {DateTime? lastCreateAt,
      int limit = LIMIT_PAGE,
      Map<String, String>? filter});

  // load more

  Stream<List<FeedBackModel>> getAllByUserId({required String userId});

  Future<void> changeStatus({String? id, required FeedBackStatus status});

  Future<void> dispose();
}

class FeedBackRepositoryImpl implements FeedBackRepository {
  final FeedBackRemoteDataSource remoteDate;

  FeedBackRepositoryImpl(this.remoteDate);

  @override
  Future<FeedBackModel?> add({required FeedBackModel feedBack}) async {
    return remoteDate.add(feedBack: feedBack);
  }

  @override
  Future<FeedBackModel?> getById({required String id}) async {
    final feedbackLocal = FeedBackModel();
    if (feedbackLocal.id != null) {
      return feedbackLocal;
    } else {
      logger.i('get feedback from remote');
    }
  }

  @override
  Future<void> delete({required String id}) async {
    return remoteDate.delete(id: id);
  }

  @override
  Future<List<FeedBackModel>> getAll(
      {DateTime? lastCreateAt,
      int limit = 15,
      Map<String, String>? filter}) async {
    return remoteDate.getAll(
        lastCreateAt: lastCreateAt, limit: limit, filter: filter);
  }

  @override
  Future<void> changeStatus(
      {String? id, required FeedBackStatus status}) async {
    return remoteDate.changeStatus(id: id, status: status.toJson());
  }

  @override
  Future<void> update({required FeedBackModel feedBack}) async {
    return remoteDate.update(feedBack: feedBack);
  }

  @override
  Stream<List<FeedBackModel>> getAllByUserId({required String userId}) async* {
    final feedbacks = remoteDate.getAllByUserId(userId: userId);

    yield* feedbacks;
  }

  @override
  Future<void> dispose() async {
    return Future.value();
  }
}
