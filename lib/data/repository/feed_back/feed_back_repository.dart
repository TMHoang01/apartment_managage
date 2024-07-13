import 'dart:async';

import 'package:apartment_managage/data/datasources/feed_back/feed_back_local.dart';
import 'package:apartment_managage/data/datasources/feed_back/feed_back_remote.dart';
import 'package:apartment_managage/domain/models/feed_back/feed_back.dart';
import 'package:apartment_managage/domain/repository/feed_back/feed_back_repository.dart';
import 'package:apartment_managage/utils/constants.dart';
import 'package:apartment_managage/utils/logger.dart';

class FeedBackRepositoryImpl implements FeedBackRepository {
  final FeedBackRemoteDataSource remoteData;
  final FeedbackLocalDataSource localData;

  FeedBackRepositoryImpl(this.remoteData, this.localData);

  @override
  Future<FeedBackModel?> add({required FeedBackModel feedBack}) async {
    final newfb = await remoteData.add(feedBack: feedBack);
    if (newfb != null) {
      await localData.addFeedbacks([newfb]);
    }
    return newfb;
  }

  @override
  Future<FeedBackModel?> getById({required String id}) async {
    final feedbackLocal = FeedBackModel();
    if (feedbackLocal.id != null) {
      return feedbackLocal;
    } else {}
  }

  @override
  Future<void> delete({required String id}) async {
    await localData.delete(id: id);
    return remoteData.delete(id: id);
  }

  late DateTime? _beginLocal;
  late DateTime? _endLocal;

  @override
  Future<List<FeedBackModel>> getAll(
      {DateTime? lastCreateAt,
      int limit = LIMIT_PAGE,
      Map<String, String>? filter}) async {
    if (lastCreateAt == null) {
      _beginLocal = await localData.getTimeBegin();
      _endLocal = await localData.getTimeEnd();
      List<FeedBackModel> list = await remoteData.getAll(
          lastCreateAt: lastCreateAt, limit: limit, filter: filter);
      await localData.addFeedbacks(list);
      DateTime? begin = list.first.createdAt;
      list = list
          .map((e) => e.copyWith(
                partion: begin,
              ))
          .toList();
      return list;
    } else {
      if (await localData.checkTimeIn(lastCreateAt)) {
        final list = await localData.getFeedback(
            timeIn: lastCreateAt, limit: limit, filter: filter);
        lastCreateAt =
            list.firstOrNull != null ? list.first.createdAt : lastCreateAt;
        final endCreateAt =
            list.lastOrNull != null ? list.last.createdAt : null;
        final lastUpdated = getMaxUpdatedAt(list);

        final listUpdate = await remoteData.getAll(
          lastCreateAt: lastCreateAt,
          limit: limit,
          filter: filter,
          endCreateAt: endCreateAt,
          lastUpdated: lastUpdated,
        );
        // logger.i(listNew);
        if (listUpdate.isNotEmpty) {
          await localData.updateListFeedbacks(listUpdate);
        }
        return list;
      } else {
        logger.t('remote get data $lastCreateAt');
      }
    }
    return [];
  }

  @override
  Future<List<FeedBackModel>> getFeedback(
      {DateTime? lastCreatedAt,
      int limit = LIMIT_PAGE,
      Map<String, String>? filter}) async {
    if (filter != null) {
      return await remoteData.getAll(
        lastCreateAt: lastCreatedAt,
        limit: limit,
        filter: filter,
      );
    }
    logger.t('lastCreateAd $lastCreatedAt');
    if (lastCreatedAt == null) {
      _beginLocal = await localData.getTimeBegin();
      _endLocal = await localData.getTimeEnd();
      var list = await remoteData.getAll(
        lastCreateAt: lastCreatedAt,
        limit: limit,
      );
      final partion = list.first.createdAt;
      list = list.map((e) => e.copyWith(partion: partion)).toList();

      await localData.getFirst(list);
      if (_beginLocal == null) {
        _beginLocal = list.first.createdAt!;
        _endLocal = list.last.createdAt;
      }
      return list;
    }

    if (lastCreatedAt.isBefore(_beginLocal!) &&
        lastCreatedAt.isAfter(_endLocal!)) {
      List<FeedBackModel> list = await localData.getLocal(
        filter: filter,
        limit: limit,
        timeIn: lastCreatedAt,
      );
      final partionValue = list.first.partion;
      lastCreatedAt =
          list.lastOrNull != null ? list.last.createdAt : lastCreatedAt;
      final endCreateAt = list.lastOrNull != null ? list.last.createdAt : null;
      final lastUpdated = getMaxUpdatedAt(list);

      final listLocalUpdate = await remoteData.getAll(
        lastCreateAt: lastCreatedAt,
        limit: limit,
        filter: filter,
        endCreateAt: endCreateAt,
        lastUpdated: lastUpdated,
      );

      if (listLocalUpdate.isNotEmpty) {
        await localData.updatePartionLocal(listLocalUpdate);
        list = _mergeLists(list, listLocalUpdate);
      }
      List<FeedBackModel> newListData = [];
      if (list.length < limit) {
        limit = limit - list.length;
        newListData = await remoteData.getAll(
          lastCreateAt: list.last.createdAt,
          limit: limit,
        );
        newListData =
            newListData.map((e) => e.copyWith(partion: partionValue)).toList();
        await localData.updateListFeedbacks(newListData);
      }
      return [...list, ...newListData];
    }

    final list = await remoteData.getAll(
      lastCreateAt: lastCreatedAt,
      limit: limit,
    );
    await localData.addPartionInLocal(list);

    return list;
  }

  List<FeedBackModel> _mergeLists(
      List<FeedBackModel> list1, List<FeedBackModel> list2) {
    final itemMap = <String, FeedBackModel>{};
    for (var item in list1) {
      itemMap[item.id!] = item;
    }
    for (var item in list2) {
      itemMap[item.id!] = item;
    }

    return itemMap.values.toList();
  }

  @override
  Future<void> changeStatus(
      {String? id, required FeedBackStatus status}) async {
    localData.changeStatus(id: id, status: status.toJson());
    return remoteData.changeStatus(id: id, status: status.toJson());
  }

  @override
  Future<void> update({required FeedBackModel feedBack}) async {
    await localData.updateFeedback(feedBack);
    return remoteData.update(feedBack: feedBack);
  }

  @override
  Stream<List<FeedBackModel>> getAllByUserId({required String userId}) async* {
    final feedbacks = remoteData.getAllByUserId(userId: userId);

    yield* feedbacks;
  }

  @override
  Future<void> dispose() async {
    return Future.value();
  }

  DateTime? getMaxUpdatedAt(List<FeedBackModel>? feedbackList) {
    if (feedbackList == null || feedbackList.isEmpty) {
      return null;
    }
    DateTime? maxDate;
    for (var feedback in feedbackList) {
      if (feedback.updatedAt != null) {
        if (maxDate == null || feedback.updatedAt!.isAfter(maxDate)) {
          maxDate = feedback.updatedAt;
        }
      }
    }
    return maxDate;
  }
}
