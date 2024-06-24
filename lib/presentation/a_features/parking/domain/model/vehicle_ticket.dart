import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:apartment_managage/utils/utils.dart';

enum TicketStatus {
  rejected,
  active,
  expired,
  pending;

  String toJson() => name;
  static TicketStatus fromJson(String json) => values.byName(json);

  String toName() {
    switch (this) {
      case TicketStatus.active:
        return 'Đang hoạt động';
      case TicketStatus.expired:
        return 'Hết hạn';
      case TicketStatus.pending:
        return 'Chờ xử lý';
      default:
        return '';
    }
  }
}

class VehicleTicket extends Equatable {
  final String? id;
  final String? ticketId;
  final String? ticketCode;

  final String? userId;
  final String? vehicleLicensePlate;
  final String? vehicleType; // car, motorbike
  final String? vehicleBarnd;
  final String? vehicleOwner;
  final DateTime? registerDate;
  final DateTime? expireDate;
  final TicketStatus? status;

  final String? parkingLotId;
  final String? parkingLotName;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  VehicleTicket({
    this.id,
    this.ticketId,
    this.ticketCode,
    this.userId,
    this.vehicleLicensePlate,
    this.vehicleType,
    this.vehicleBarnd,
    this.vehicleOwner,
    this.registerDate,
    this.expireDate,
    this.status,
    this.parkingLotId,
    this.parkingLotName,
    this.createdAt,
    this.updatedAt,
  });
  // bool compare Date
  get isExpired => DateTime.now().isAfter(expireDate!);

  String get statusName {
    if (status == TicketStatus.active && isExpired) {
      return 'Hết hạn';
    }
    return status?.toName() ?? '';
  }

  @override
  List<Object?> get props => [
        id,
        ticketId,
        ticketCode,
        userId,
        vehicleLicensePlate,
        vehicleType,
        vehicleBarnd,
        vehicleOwner,
        registerDate,
        expireDate,
        status,
        parkingLotId,
        parkingLotName,
        createdAt,
        updatedAt,
      ];

  factory VehicleTicket.fromJson(Map<String, dynamic> json) {
    TicketStatus statusEnum = json['status'] != null
        ? TicketStatus.fromJson(json['status'])
        : TicketStatus.pending;
    final isExpired = json['expireDate'] != null
        ? DateTime.now().isAfter(TextFormat.parseJson(json['expireDate'])!)
        : false;
    if (statusEnum == TicketStatus.active && isExpired) {
      statusEnum = TicketStatus.expired;
    }
    return VehicleTicket(
      id: json['id'],
      ticketId: json['ticketId'],
      ticketCode: json['ticketCode'],
      userId: json['userId'],
      vehicleLicensePlate: json['vehicleLicensePlate'],
      vehicleType: json['vehicleType'],
      vehicleBarnd: json['vehicleBarnd'],
      vehicleOwner: json['vehicleOwner'],
      registerDate: TextFormat.parseJson(json['registerDate']),
      expireDate: TextFormat.parseJson(json['expireDate']),
      status: statusEnum,
      parkingLotId: json['parkingLotId'],
      parkingLotName: json['parkingLotName'],
      createdAt: TextFormat.parseJson(json['createdAt']),
      updatedAt: TextFormat.parseJson(json['updatedAt']),
    );
  }

  factory VehicleTicket.fromDocumentSnapshot(DocumentSnapshot doc) {
    return VehicleTicket.fromJson(doc.data() as Map<String, dynamic>).copyWith(
      id: doc.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (ticketId != null) 'ticketId': ticketId,
      if (ticketCode != null) 'ticketCode': ticketCode,
      if (userId != null) 'userId': userId,
      if (vehicleLicensePlate != null)
        'vehicleLicensePlate': vehicleLicensePlate,
      if (vehicleType != null) 'vehicleType': vehicleType,
      if (vehicleBarnd != null) 'vehicleBarnd': vehicleBarnd,
      if (vehicleOwner != null) 'vehicleOwner': vehicleOwner,
      if (registerDate != null) 'registerDate': registerDate,
      if (expireDate != null) 'expireDate': expireDate,
      if (status != null) 'status': status?.toJson(),
      if (parkingLotId != null) 'parkingLotId': parkingLotId,
      if (parkingLotName != null) 'parkingLotName': parkingLotName,
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
    };
  }

  VehicleTicket copyWith(
      {String? id,
      String? ticketId,
      String? ticketCode,
      String? userId,
      String? vehicleLicensePlate,
      String? vehicleType,
      String? vehicleBarnd,
      String? vehicleOwner,
      DateTime? registerDate,
      DateTime? expireDate,
      TicketStatus? status,
      String? parkingLotId,
      String? parkingLotName,
      DateTime? createdAt,
      DateTime? updatedAt}) {
    return VehicleTicket(
      id: id ?? this.id,
      ticketId: ticketId ?? this.ticketId,
      ticketCode: ticketCode ?? this.ticketCode,
      userId: userId ?? this.userId,
      vehicleLicensePlate: vehicleLicensePlate ?? this.vehicleLicensePlate,
      vehicleType: vehicleType ?? this.vehicleType,
      vehicleBarnd: vehicleBarnd ?? this.vehicleBarnd,
      vehicleOwner: vehicleOwner ?? this.vehicleOwner,
      registerDate: registerDate ?? this.registerDate,
      expireDate: expireDate ?? this.expireDate,
      status: status ?? this.status,
      parkingLotId: parkingLotId ?? this.parkingLotId,
      parkingLotName: parkingLotName ?? this.parkingLotName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
