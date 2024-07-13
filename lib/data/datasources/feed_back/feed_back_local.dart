import 'dart:convert';

import 'package:apartment_managage/domain/models/feed_back/feed_back.dart';
import 'package:apartment_managage/utils/constants.dart';
import 'package:apartment_managage/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackLocalDataSource {
  FeedbackLocalDataSource();
  static const String _key = 'feedback_list';
  static const String _keyTimeBegin = 'feedback_timeBegin';
  static const String _keyTimeEnd = 'feedback_timeEnd';
  List<FeedBackModel> _list = [];
  late DateTime _begin;
  late DateTime _end;

  static const int _maxSize = 200;
  Future<void> _settimeBegin(DateTime date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String strTime = date.toIso8601String();
      prefs.setString(_keyTimeBegin, strTime);
    } catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<void> _setTimeEnd(DateTime date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyTimeEnd, date.toIso8601String());
    } catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<DateTime?> getTimeBegin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_keyTimeBegin);

      if (data == null) return null;
      _begin = DateTime.parse(data);
      return DateTime.parse(data);
    } catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<DateTime?> getTimeEnd() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_keyTimeEnd);
      if (data == null) return null;
      _end = DateTime.parse(data);

      return DateTime.parse(data);
    } catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<void> _updateLocal() async {
    try {
      if (_list.isEmpty) return;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      _list = _list.take(_maxSize).toList();
      final save = _list.map((e) => e.jsEncode()).toList();
      final begin = _list.first.createdAt?.toIso8601String();
      final end = _list.last.createdAt?.toIso8601String();
      prefs.setString(_keyTimeEnd, end!);
      prefs.setString(_keyTimeBegin, begin!);
      prefs.setStringList(_key, save);
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> getFirst(List<FeedBackModel> feedback) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> fbDataLocal = prefs.getStringList(_key) ?? [];
      _list = fbDataLocal.map((item) {
        return FeedBackModel.decode(item);
      }).toList();

      if (_list.isEmpty) {
        logger.i(' Not data in local');
        _list = feedback;
        _begin = feedback.first.createdAt!;
        _end = feedback.last.createdAt!;
        _updateLocal();
        return;
      }
      logger.i(fbDataLocal.firstOrNull);
      logger.i(fbDataLocal.lastOrNull);

      DateTime? partionNewValue = feedback.first.createdAt;
      final lastNewItem = feedback.last.updatedAt;
      feedback =
          feedback.map((e) => e.copyWith(partion: partionNewValue)).toList();

      if (lastNewItem != null && lastNewItem.isBefore(_begin) == true) {
        final localFirstPartion = feedback.first.partion;
        _list = _list.map((e) {
          if (e.partion!.isAtSameMomentAs(localFirstPartion!)) {
            e = e.copyWith(
              partion: partionNewValue,
            );
          }

          return e;
        }).toList();
      }
      await _updateLocal();
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  Future<void> addListPartionInLocal(List<FeedBackModel> feedBack) async {
    Map<DateTime, List<FeedBackModel>> listParts = {};
    for (var element in feedBack) {
      DateTime? date = element.partion;
      if (listParts.containsKey(element.partion)) {
        if (date != null) {
          if (!listParts.containsKey(date)) {
            listParts[date] = [];
          }
          listParts[date]!.add(element);
        }
      }
    }

    listParts.forEach((key, value) {
      print('Group $key: ${value.length}');
      addPartionInLocal(value);
    });
  }

  Future<void> addPartionInLocal(List<FeedBackModel> newPartion) async {
    try {
      if (newPartion.isEmpty) return;
      final beginNewPartion = newPartion.firstOrNull?.createdAt;
      final endNewPartion = newPartion.lastOrNull?.createdAt;

      // new begin >> new end >> local begin
      if (beginNewPartion!.isAfter(_begin) && endNewPartion!.isAfter(_begin)) {
        _list.insertAll(0, newPartion);
        await _updateLocal();
        return;
      }
      // new begin >> local begin >> new end >> local end
      if (beginNewPartion.isAfter(_begin) &&
          endNewPartion!.isBefore(_begin) &&
          endNewPartion.isAfter(_end)) {
        final firstPartionLocal = _list.firstOrNull?.partion;
        _list.removeWhere((element) =>
            element.createdAt!.isAfter(endNewPartion) ||
            element.createdAt!.isAtSameMomentAs(endNewPartion));
        _list = _list.map((e) {
          if (e.partion!.isAtSameMomentAs(firstPartionLocal!)) {
            e = e.copyWith(partion: beginNewPartion);
          }
          return e;
        }).toList();
        await _updateLocal();
        return;
      }
      // new begin >> local bewgin >> local end >> new begin
      if (beginNewPartion.isAfter(_begin) && endNewPartion!.isBefore(_end)) {
        _list = newPartion;
        await _updateLocal();
        return;
      }

      // local  begin >> local end >> new begin
      if (beginNewPartion.isBefore(_end)) {
        final lastPartionLocal = _list.lastOrNull?.partion;
        newPartion = newPartion
            .map(
                (e) => e.copyWith(partion: lastPartionLocal ?? beginNewPartion))
            .toList();
        _list.addAll(newPartion);
        await _updateLocal();
        return;
      }

      int beginIndex = _list.indexWhere(
          (element) => element.createdAt!.isAtSameMomentAs(beginNewPartion));
      var partionValue = _list[beginIndex].partion;
      if (beginIndex < 0) {
        beginIndex = _list.indexWhere(
          (element) => element.createdAt!.isBefore(beginNewPartion),
        );
        partionValue = _list[beginIndex - 1].partion;
      }

      int endIndex = _list.indexWhere(
        (element) =>
            element.createdAt!.isAtSameMomentAs(endNewPartion!) ||
            element.createdAt!.isBefore(endNewPartion!),
      );
      endIndex = endIndex < 0 ? _list.length - 1 : endIndex;
      if (beginIndex >= 0) {
        _list.removeRange(beginIndex, endIndex);
      }
      newPartion =
          newPartion.map((e) => e.copyWith(partion: partionValue)).toList();
      _list.addAll(newPartion);
      await _updateLocal();
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<void> updatePartionLocal(List<FeedBackModel> partion) async {
    for (var fb in partion) {
      int index = _list.indexWhere((element) => element.id == fb.id);
      if (index < 0) {
        index = _list.indexWhere(
            (element) => element.createdAt!.isBefore(fb.createdAt!));
        _list.insert(index, fb);
      } else {
        _list[index] = fb;
      }
    }
  }

  Future<bool> checkTimeIn(DateTime time) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final begin = prefs.getString(_keyTimeBegin);
      final end = prefs.getString(_keyTimeEnd);
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
      rethrow;
    }
  }

  Future<void> addFirst(List<FeedBackModel> newList) async {}

  Future<void> update(List<FeedBackModel> newList) async {}

  Future<void> addFeedbacks(List<FeedBackModel> feedback) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final List<String> newData = feedback.map((e) => e.jsEncode()).toList();
      List<String> existingListData = prefs.getStringList(_key) ?? [];
      List<FeedBackModel> list = existingListData.map((item) {
        return FeedBackModel.decode(item);
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
      // logger.f('add ${feedback.length} -> ${combinedData.length}');
      FeedBackModel? fbBegin = combinedData.firstOrNull != null
          ? FeedBackModel.decode(combinedData.first)
          : null;
      FeedBackModel? fbEnd = combinedData.lastOrNull != null
          ? FeedBackModel.decode(combinedData.last)
          : null;
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
    prefs.remove(_keyTimeBegin);
    prefs.remove(_keyTimeEnd);
  }

  // Future<void> removeFeedback(List<FeedBackModel> feedback) async {}

  Future<void> updateListFeedbacks(List<FeedBackModel> feedbacks) async {
    try {
      if (feedbacks.isEmpty) return;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String> fbDataLocal = prefs.getStringList(_key) ?? [];
      List<FeedBackModel> listLocal = fbDataLocal.map((item) {
        return FeedBackModel.decode(item);
      }).toList();
      final beginDate = feedbacks.first.createdAt;
      final endDate = feedbacks.last.createdAt;

      final beginIndex = listLocal
          .indexWhere((element) => element.createdAt!.isBefore(beginDate!));
      final endIndex = listLocal
          .indexWhere((element) => element.createdAt!.isAfter(beginDate!));

      if (beginIndex < 0 && endIndex < 0) {
        listLocal = feedbacks;
      } else if (beginIndex < 0) {
        listLocal = listLocal.sublist(endIndex);
        listLocal.insertAll(0, feedbacks);
      } else if (endIndex < 0) {
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
        return FeedBackModel.decode(item);
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

  Future<List<FeedBackModel>> getLocal(
      {DateTime? timeIn,
      int limit = LIMIT_PAGE,
      Map<String, String>? filter}) async {
    try {
      final index =
          _list.indexWhere((element) => element.createdAt!.isBefore(timeIn!));
      final partionValue = _list[index].partion;
      if (index < 0) return [];
      final result = _list
          .sublist(index)
          .where((element) => element.partion!.isAtSameMomentAs(partionValue!))
          .take(15)
          .toList();
      print(
          'result local ${result.first.partion} : ${result.length}   ||| \n ${result.first.createdAt} ->${result.last.createdAt}');
      return result;
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
            return FeedBackModel.decode(item);
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

  // FeedBackModel _decode(String taskJson) {
  //   final taskData = json.decode(taskJson);
  //   DateTime createdAt = DateTime.parse(
  //       taskData['createdAt'] ?? DateTime.now().millisecondsSinceEpoch);
  //   DateTime updatedAt = DateTime.parse(
  //       taskData['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch);
  //   DateTime partion = DateTime.parse(
  //       taskData['partion'] ?? DateTime.now().millisecondsSinceEpoch);
  //   taskData['createdAt'] = createdAt;
  //   taskData['updatedAt'] = updatedAt;
  //   taskData['partion'] = partion;

  //   return FeedBackModel.fromJson(taskData);
  // }

  void changeStatus({String? id, required String status}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String> fb = prefs.getStringList(_key) ?? [];
      List<FeedBackModel> list = fb.map((item) {
        return FeedBackModel.decode(item);
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
        return FeedBackModel.decode(item);
      }).toList();

      list = list.where((element) => id != element.id).toList();

      await prefs.setStringList(_key, list.map((e) => e.jsEncode()).toList());
    } catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }
}
