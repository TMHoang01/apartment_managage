import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingHistory extends Equatable {
  final String? id;
  final String? ticketId;
  final String? vehicleLicensePlate;
  final String? vehicleType; // car, motorbike
  final String? imgIn;
  final String? imgOut;
  final DateTime? timeIn;
  final DateTime? timeOut;
  final String? lotId;

  ParkingHistory({
    this.id,
    this.ticketId,
    this.vehicleType,
    this.vehicleLicensePlate,
    this.lotId,
    this.imgIn,
    this.imgOut,
    this.timeIn,
    this.timeOut,
  });

  factory ParkingHistory.fromJson(Map<String, dynamic> json) {
    return ParkingHistory(
      id: json['id'],
      ticketId: json['ticketId'],
      vehicleLicensePlate: json['vehicleLicensePlate'],
      vehicleType: json['vehicleType'],
      imgIn: json['imgIn'],
      imgOut: json['imgOut'],
      timeIn: json['timeIn'],
      timeOut: json['timeOut'],
      lotId: json['lotId'],
    );
  }

  factory ParkingHistory.fromDocument(DocumentSnapshot doc) {
    return ParkingHistory.fromJson(doc.data() as Map<String, dynamic>)
        .copyWith(id: doc.id);
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (ticketId != null) 'ticketId': ticketId,
      if (vehicleLicensePlate != null)
        'vehicleLicensePlate': vehicleLicensePlate,
      if (vehicleType != null) 'vehicleType': vehicleType,
      if (imgIn != null) 'imgIn': imgIn,
      if (imgOut != null) 'imgOut': imgOut,
      if (timeIn != null) 'timeIn': timeIn,
      if (timeOut != null) 'timeOut': timeOut,
      if (lotId != null) 'lotId': lotId,
    };
  }

  ParkingHistory copyWith({
    String? id,
    String? ticketId,
    String? vehicleLicensePlate,
    String? vehicleType,
    String? imgIn,
    String? imgOut,
    DateTime? timeIn,
    DateTime? timeOut,
    String? lotId,
  }) {
    return ParkingHistory(
      id: id ?? this.id,
      ticketId: ticketId ?? this.ticketId,
      vehicleLicensePlate: vehicleLicensePlate ?? this.vehicleLicensePlate,
      vehicleType: vehicleType ?? this.vehicleType,
      imgIn: imgIn ?? this.imgIn,
      imgOut: imgOut ?? this.imgOut,
      timeIn: timeIn ?? this.timeIn,
      timeOut: timeOut ?? this.timeOut,
      lotId: lotId ?? this.lotId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        ticketId,
        vehicleLicensePlate,
        vehicleType,
        imgIn,
        imgOut,
        timeIn,
        timeOut,
        lotId,
      ];
}
