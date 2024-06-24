import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:apartment_managage/utils/utils.dart';

import './enum_service.dart';

class ScheduleBooking extends Equatable {
  final DateTime? startDate;
  final TimeOfDay? startTime;
  final bool? isReapeat;
  final DateTime? endDate;
  int? repeatCount; // length List<DateTime>
  final BookingRepeatType? repeatType; //  ngày, tuần, tháng
  final List<int>? dayRepeat; // 1,2,3,4,5,6,7
  List<DateTime>? scheduleDates;
  int get scheduleCount => scheduleDates?.length ?? 0;

  ScheduleBooking({
    this.startDate,
    this.startTime,
    this.endDate,
    this.isReapeat,
    this.repeatCount,
    this.repeatType,
    this.dayRepeat,
    this.scheduleDates,
  });

  factory ScheduleBooking.fromJson(Map<String, dynamic> json) {
    return ScheduleBooking(
      startDate: TextFormat.parseJson(json['startDate']),
      startTime: json['startTime'] != null
          ? TimeOfDay(
              hour: int.parse(json['startTime'].split(':')[0]),
              minute: int.parse(json['startTime'].split(':')[1]),
            )
          : null,
      endDate: TextFormat.parseJson(json['endDate']),
      repeatCount: json['repeatCount'],
      isReapeat: json['isReapeat'],
      repeatType: json['repeatType'] != null
          ? BookingRepeatType.fromJson(json['repeatType'])
          : null,
      dayRepeat:
          json['dayRepeat'] != null ? List<int>.from(json['dayRepeat']) : [],
      // List<string> to DateTime
      scheduleDates: json['scheduleDates'] != null
          ? List<DateTime>.from(json['scheduleDates']
              .map((date) => TextFormat.parseJsonFormat(date)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (startDate != null) 'startDate': startDate,
      if (startTime != null)
        'startTime': '${startTime!.hour}:${startTime!.minute}',
      if (endDate != null) 'endDate': endDate,
      if (repeatCount != null) 'repeatCount': repeatCount,
      if (isReapeat != null) 'isReapeat': isReapeat,
      if (repeatType != null) 'repeatType': repeatType?.toJson(),
      if (dayRepeat != null) 'dayRepeat': dayRepeat,
      if (scheduleDates != null)
        'scheduleDates': scheduleDates
            ?.map((dateTime) => TextFormat.formatDate(dateTime))
            .toList(),
    };
  }

  ScheduleBooking copyWith({
    DateTime? startDate,
    TimeOfDay? startTime,
    DateTime? endDate,
    bool? isReapeat,
    BookingRepeatType? repeatType,
    List<int>? dayRepeat,
    int? repeatCount,
    List<DateTime>? scheduleDates,
  }) {
    return ScheduleBooking(
      startDate: startDate ?? this.startDate,
      startTime: startTime ?? this.startTime,
      endDate: endDate ?? this.endDate,
      isReapeat: isReapeat ?? this.isReapeat,
      repeatCount: repeatCount ?? this.repeatCount,
      repeatType: repeatType ?? this.repeatType,
      dayRepeat: dayRepeat ?? this.dayRepeat,
      scheduleDates: scheduleDates ?? this.scheduleDates,
    );
  }

  void setScheduleDates() {
    if (isReapeat == false) {
      scheduleDates = [startDate!];
      repeatCount = 1;
      return;
    }
    if (startDate == null ||
        endDate == null ||
        repeatType == null ||
        dayRepeat == null) {
      scheduleDates = [];
      return;
    }

    const increasesDay = Duration(days: 1);
    scheduleDates = [];

    if (repeatType == BookingRepeatType.weekly) {
      for (DateTime date = startDate!;
          date.isBefore(endDate!);
          date = date.add(increasesDay)) {
        if (dayRepeat!.contains(date.weekday)) {
          scheduleDates!.add(date);
        }
      }
    } else if (repeatType == BookingRepeatType.monthly) {
      for (DateTime date = startDate!;
          date.isBefore(endDate!);
          date = date.add(increasesDay)) {
        if (dayRepeat!.contains(date.day)) {
          scheduleDates!.add(date);
        }
      }
    } else {
      for (DateTime date = startDate!;
          date.isBefore(endDate!);
          date = date.add(increasesDay)) {
        scheduleDates!.add(date);
      }
    }
    repeatCount = scheduleDates!.length;
  }

  void addScheduleDate(DateTime date) {
    scheduleDates ??= [];
    scheduleDates!.add(date);
    repeatCount = scheduleDates!.length;
  }

  void removeScheduleDate(DateTime date) {
    if (scheduleDates == null) {
      return;
    }
    scheduleDates!.remove(date);
  }

  @override
  List<Object?> get props => [
        startDate,
        endDate,
        isReapeat,
        repeatCount,
        repeatType,
        dayRepeat,
        scheduleDates
      ];
}

class ScheduleItem {
  final DateTime date; // Ngày hẹn
  final TimeOfDay? time; // Giờ hẹn
  final String status;
  final String? note; // Ghi chú

  ScheduleItem({
    required this.date,
    this.time,
    required this.status,
    this.note,
  });
}
