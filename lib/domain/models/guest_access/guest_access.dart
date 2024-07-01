import 'package:apartment_managage/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GuestAccess extends Equatable {
  String? id;
  String? guestId;
  String? guestName;
  String? guestPhone;
  String? guestCccd;
  String? purpose;
  String? residentId;
  String? apartmentId;
  String? residentName;
  DateTime? expectedTime;
  DateTime? checkInTime;
  DateTime? checkOutTime;
  String? status;

  String? createdBy;
  DateTime? createdAt;
  String? updatedBy;
  DateTime? updatedAt;

  bool get isCheckIn => status == 'checkIn';
  bool get isCheckOut => status == 'checkOut';
  bool get isCancel => status == 'cancel';
  bool get isPending => status == 'pending' || status == null;
  bool get isOutDate =>
      expectedTime != null && expectedTime!.isBefore(DateTime.now());

  GuestAccess(
      {this.id,
      this.guestId,
      this.guestName,
      this.guestPhone,
      this.guestCccd,
      this.purpose,
      this.residentId,
      this.apartmentId,
      this.residentName,
      this.expectedTime,
      this.checkInTime,
      this.checkOutTime,
      this.status,
      this.createdBy,
      this.createdAt,
      this.updatedBy,
      this.updatedAt});

  String get statusText {
    switch (status) {
      case 'pending':
        return 'Chờ xác nhận';
      case 'checkIn':
        return 'Đã xác nhận đến';
      case 'checkOut':
        return 'Hoàn thành';
      case 'cancel':
        return 'Đã hủy';
      default:
        return 'Chờ xác nhận';
    }
  }

  Color get statusColor {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'checkIn':
        return Colors.green;
      case 'checkOut':
        return Colors.blue;
      case 'cancel':
        return Colors.red;

      default:
        return Colors.orange;
    }
  }

  factory GuestAccess.fromJson(Map<String, dynamic> json) {
    return GuestAccess(
      id: json['id'],
      guestId: json['guestId'],
      guestName: json['guestName'],
      guestPhone: json['guestPhone'],
      guestCccd: json['guestCccd'],
      purpose: json['purpose'],
      residentId: json['residentId'],
      apartmentId: json['apartmentId'],
      residentName: json['residentName'],
      expectedTime: TextFormat.parseJson(json['expectedTime']),
      checkInTime: TextFormat.parseJson(json['checkInTime']),
      checkOutTime: TextFormat.parseJson(json['checkOutTime']),
      status: json['status'],
      createdBy: json['createdBy'],
      createdAt: TextFormat.parseJson(json['createdAt']),
      updatedBy: json['updatedBy'],
      updatedAt: TextFormat.parseJson(json['updatedAt']),
    );
  }

  factory GuestAccess.fromSnapshot(DocumentSnapshot snapshot) {
    return GuestAccess.fromJson(snapshot.data() as Map<String, dynamic>)
        .copyWith(id: snapshot.id);
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (guestId != null) 'guestId': guestId,
      if (guestName != null) 'guestName': guestName,
      if (guestPhone != null) 'guestPhone': guestPhone,
      if (guestCccd != null) 'guestCccd': guestCccd,
      if (purpose != null) 'purpose': purpose,
      if (residentId != null) 'residentId': residentId,
      if (apartmentId != null) 'apartmentId': apartmentId,
      if (residentName != null) 'residentName': residentName,
      if (expectedTime != null) 'expectedTime': expectedTime,
      if (checkInTime != null) 'checkInTime': checkInTime,
      if (checkOutTime != null) 'checkOutTime': checkOutTime,
      if (status != null) 'status': status,
      if (createdBy != null) 'createdBy': createdBy,
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedBy != null) 'updatedBy': updatedBy,
      if (updatedAt != null) 'updatedAt': updatedAt,
    };
  }

  GuestAccess copyWith({
    String? id,
    String? guestId,
    String? guestName,
    String? guestPhone,
    String? guestCccd,
    String? purpose,
    String? residentId,
    String? apartmentId,
    String? residentName,
    DateTime? expectedTime,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    String? status,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
  }) {
    return GuestAccess(
      id: id ?? this.id,
      guestId: guestId ?? this.guestId,
      guestName: guestName ?? this.guestName,
      guestPhone: guestPhone ?? this.guestPhone,
      guestCccd: guestCccd ?? this.guestCccd,
      purpose: purpose ?? this.purpose,
      residentId: residentId ?? this.residentId,
      apartmentId: apartmentId ?? this.apartmentId,
      residentName: residentName ?? this.residentName,
      expectedTime: expectedTime ?? this.expectedTime,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        guestId,
        guestName,
        guestPhone,
        guestCccd,
        purpose,
        residentId,
        apartmentId,
        residentName,
        expectedTime,
        checkInTime,
        checkOutTime,
        status,
        createdBy,
        createdAt,
        updatedBy,
        updatedAt
      ];
}
