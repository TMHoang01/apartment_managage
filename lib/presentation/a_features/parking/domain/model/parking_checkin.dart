import 'package:apartment_managage/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ParkingCheckIn extends Equatable {
  final String? id;
  final String? ticketCode;
  final bool? isMonthlyTicket;
  final String? vehicleLicensePlate;
  final String? vehicleType; // car, motorbike
  final String? imgIn;
  final String? imgOut;
  final DateTime? timeIn;
  final DateTime? timeOut;
  final String? lotId;
  num price;

  bool get isLicensePlateEmpty =>
      vehicleLicensePlate == null || vehicleLicensePlate!.isEmpty;

  bool get isOut => timeOut != null;

  setPrice() {
    if (ticketCode == null) price = 0.0;
    if (isMonthlyTicket == true) price = 0.0;
    // gửi trong ngày vào ra để tính giá gửi vào trong khoảng [6,18h] ban ngày 3k, tối 5k, nếu gửi qua đêm thì 10k/ ngày
    if (timeIn != null && timeOut != null) {
      final TimeOfDay hourIn = TimeOfDay.fromDateTime(timeIn!);
      final TimeOfDay hourOut = TimeOfDay.fromDateTime(timeOut!);
      const TimeOfDay time6 = TimeOfDay(hour: 6, minute: 0);
      const TimeOfDay time18 = TimeOfDay(hour: 18, minute: 0);
      final duration = timeOut!.difference(timeIn!);
      double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

      const priceOverNight = 10000;
      const priceDay = 3000;
      const priceNight = 5000;
      int numDay = duration.inDays;
      int hours = duration.inHours;
      price = 0.0;
      if (numDay > 0) {
        price = priceOverNight * numDay;
      } else if (toDouble(hourIn) >= toDouble(time6) &&
          toDouble(hourOut) <= toDouble(time18)) {
        price = priceDay;
      } else {
        price = priceNight;
      }
    }
  }

  ParkingCheckIn({
    this.id,
    this.ticketCode,
    this.isMonthlyTicket,
    this.vehicleType,
    this.vehicleLicensePlate,
    this.lotId,
    this.imgIn,
    this.imgOut,
    this.timeIn,
    this.timeOut,
    this.price = 0.0,
  });

  factory ParkingCheckIn.fromJson(Map<String, dynamic> json) {
    return ParkingCheckIn(
      id: json['id'],
      ticketCode: json['ticketCode'],
      isMonthlyTicket: json['isMonthlyTicket'],
      vehicleLicensePlate: json['vehicleLicensePlate'],
      vehicleType: json['vehicleType'],
      imgIn: json['imgIn'],
      imgOut: json['imgOut'],
      timeIn: TextFormat.parseJson(json['timeIn']),
      timeOut: TextFormat.parseJson(json['timeOut']),
      lotId: json['lotId'],
      price: json['price'] ?? 0.0,
    );
  }

  factory ParkingCheckIn.fromDocument(DocumentSnapshot doc) {
    return ParkingCheckIn.fromJson(doc.data() as Map<String, dynamic>)
        .copyWith(id: doc.id);
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (ticketCode != null) 'ticketCode': ticketCode,
      if (isMonthlyTicket != null) 'isMonthlyTicket': isMonthlyTicket,
      if (vehicleLicensePlate != null)
        'vehicleLicensePlate': vehicleLicensePlate,
      if (vehicleType != null) 'vehicleType': vehicleType,
      if (imgIn != null) 'imgIn': imgIn,
      if (imgOut != null) 'imgOut': imgOut,
      'timeIn': timeIn,
      'timeOut': timeOut,
      if (lotId != null) 'lotId': lotId,
    };
  }

  ParkingCheckIn copyWith({
    String? id,
    String? ticketCode,
    bool? isMonthlyTicket,
    String? vehicleLicensePlate,
    String? vehicleType,
    String? imgIn,
    String? imgOut,
    DateTime? timeIn,
    DateTime? timeOut,
    String? lotId,
    num? price,
  }) {
    return ParkingCheckIn(
      id: id ?? this.id,
      ticketCode: ticketCode ?? this.ticketCode,
      isMonthlyTicket: isMonthlyTicket ?? this.isMonthlyTicket,
      vehicleLicensePlate: vehicleLicensePlate ?? this.vehicleLicensePlate,
      vehicleType: vehicleType ?? this.vehicleType,
      imgIn: imgIn ?? this.imgIn,
      imgOut: imgOut ?? this.imgOut,
      timeIn: timeIn ?? this.timeIn,
      timeOut: timeOut ?? this.timeOut,
      lotId: lotId ?? this.lotId,
      price: price ?? this.price,
    );
  }

  @override
  List<Object?> get props => [
        id,
        ticketCode,
        vehicleLicensePlate,
        vehicleType,
        imgIn,
        imgOut,
        timeIn,
        timeOut,
        lotId,
        price,
      ];
}
