import 'dart:convert';

import 'package:apartment_managage/domain/models/feed_back/feed_back.dart';
import 'package:apartment_managage/utils/constants.dart';
import 'package:apartment_managage/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackLocalDataSource {
  FeedbackLocalDataSource();
  static const String _key = 'feedback_list';
  static const String _timeBegin = 'feedback_timeBegin';
  static const String _timeEnd = 'feedback_timeEnd';

  static const int _maxSize = 100;
  Future<void> _settimeBegin(DateTime date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String strTime = date.toIso8601String();
      prefs.setString(_timeBegin, strTime);
    } catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<void> _setTimeEnd(DateTime date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_timeEnd, date.toIso8601String());
    } catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<DateTime?> getTimeBegin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_timeBegin);
      if (data == null) return null;
      return DateTime.parse(data);
    } catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<bool> checkTimeIn(DateTime time) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final begin = prefs.getString(_timeBegin);
      final end = prefs.getString(_timeEnd);
      if (begin == null && end == null) return false;
      // return begin timeEpoch && timeEpoch > end!;

      DateTime timeBegin = DateTime.parse(begin!);
      DateTime timeEnd = DateTime.parse(end!);
      logger.w('$begin || $time ||  $end' +
          '${time.isBefore(timeBegin)} - ${time.isAtSameMomentAs(timeBegin)} - ${time.isAfter(timeEnd)}');

      return (time.isBefore(timeBegin) || time.isAtSameMomentAs(timeBegin)) &&
          time.isAfter(timeEnd);
    } catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<void> addFeedbacks(List<FeedBackModel> feedback) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final List<String> newData = feedback.map((e) => e.jsEncode()).toList();
      List<String> existingListData = prefs.getStringList(_key) ?? [];
      List<FeedBackModel> list = existingListData.map((item) {
        return _decode(item);
      }).toList();
      final FeedBackModel? lastNewData = list.lastOrNull;
      if (lastNewData != null) {
        int index = list.indexWhere(
            (element) => element.createdAt!.isBefore(lastNewData.createdAt!));

        if (index > 0) {
          existingListData = existingListData.sublist(index);
        }
      }

      List<String> combinedData = [...newData, ...existingListData];
      if (combinedData.length > _maxSize) {
        combinedData = combinedData.take(_maxSize).toList();
      }
      logger.f('add ${feedback.length} -> ${combinedData.length}');
      FeedBackModel? fbBegin =
          combinedData.firstOrNull != null ? _decode(combinedData.first) : null;
      FeedBackModel? fbEnd =
          combinedData.lastOrNull != null ? _decode(combinedData.last) : null;
      if (fbBegin != null && fbEnd != null) {
        _settimeBegin(fbBegin.createdAt!);
        _setTimeEnd(fbEnd.createdAt!);
        // logger.t('local get data  ${fbBegin.createdAt!} ${fbEnd.createdAt!}');
        // logger.t('local get data  ${fbBegin.id!} ${fbEnd.id!}');
      }

      // Save combined data to SharedPreferences
      await prefs.setStringList(_key, combinedData);
    } catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<void> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_key);
    prefs.remove(_timeBegin);
    prefs.remove(_timeEnd);
  }

  // Future<void> removeFeedback(List<FeedBackModel> feedback) async {}

  Future<void> updateListFeedbacks(List<FeedBackModel> feedbacks) async {
    try {
      if (feedbacks.isEmpty) return;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String> fbDataLocal = prefs.getStringList(_key) ?? [];
      List<FeedBackModel> listLocal = fbDataLocal.map((item) {
        return _decode(item);
      }).toList();
      final beginDate = feedbacks.first.createdAt;
      final endDate = feedbacks.last.createdAt;

      final beginIndex = listLocal
          .indexWhere((element) => element.createdAt!.isBefore(beginDate!));
      final endIndex = listLocal
          .indexWhere((element) => element.createdAt!.isAfter(beginDate!));

      if (beginIndex == -1 && endIndex == -1) {
        listLocal = feedbacks;
      } else if (beginIndex == -1) {
        listLocal = listLocal.sublist(endIndex);
        listLocal.insertAll(0, feedbacks);
      } else if (endIndex == -1) {
        listLocal = listLocal.take(beginIndex).toList();
        listLocal.addAll(feedbacks);
      } else {
        listLocal.removeRange(beginIndex, endIndex);
        listLocal.insertAll(beginIndex, feedbacks);
      }

      for (var item in feedbacks) {
        final index = listLocal.indexWhere((element) => item.id == element.id);
        if (index != -1) {
          listLocal[index] = item;
        }
      }

      final save = listLocal.map((e) => e.jsEncode()).toList();
      _settimeBegin(listLocal.first.createdAt!);
      _setTimeEnd(listLocal.last.createdAt!);
      await prefs.setStringList(_key, save);
    } catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<void> updateFeedback(FeedBackModel feedback) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String> fb = prefs.getStringList(_key) ?? [];
      List<FeedBackModel> list = fb.map((item) {
        return _decode(item);
      }).toList();

      final index = list.indexWhere((element) => feedback.id == element.id);
      if (index != -1) {
        list[index] = feedback;
      }
      await prefs.setStringList(_key, list.map((e) => e.jsEncode()).toList());
    } catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<List<FeedBackModel>> getFeedback(
      {DateTime? timeIn,
      int limit = LIMIT_PAGE,
      Map<String, String>? filter}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String> fb = prefs.getStringList(_key) ?? [];

      // logger.w('${json.decode(fb.toString())}');
      logger.w('${fb.length}');
      if (fb.isEmpty) return [];

      List<FeedBackModel> list = fb
          .map((item) {
            return _decode(item);
          })
          .toList()
          .take(limit)
          .toList();
      if (timeIn != null) {
        return list
            .where((element) => timeIn.isAfter(element.createdAt!))
            .take(limit)
            .toList();
      }
      return list;
    } catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  FeedBackModel _decode(String taskJson) {
    final taskData = json.decode(taskJson);
    DateTime createdAt = DateTime.parse(
        taskData['createdAt'] ?? DateTime.now().millisecondsSinceEpoch);
    DateTime updatedAt = DateTime.parse(
        taskData['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch);
    taskData['createdAt'] = createdAt;
    taskData['updatedAt'] = updatedAt;
    return FeedBackModel.fromJson(taskData);
  }

  void changeStatus({String? id, required String status}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String> fb = prefs.getStringList(_key) ?? [];
      List<FeedBackModel> list = fb.map((item) {
        return _decode(item);
      }).toList();

      final index = list.indexWhere((element) => id == element.id);
      if (index != -1) {
        list[index] =
            list[index].copyWith(status: FeedBackStatus.fromJson(status));
      }

      await prefs.setStringList(_key, list.map((e) => e.jsEncode()).toList());
    } catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<void> delete({String? id}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String> fb = prefs.getStringList(_key) ?? [];
      List<FeedBackModel> list = fb.map((item) {
        return _decode(item);
      }).toList();

      list = list.where((element) => id != element.id).toList();

      await prefs.setStringList(_key, list.map((e) => e.jsEncode()).toList());
    } catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }
}
