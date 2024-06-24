import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:apartment_managage/domain/models/ecom/infor_contact.dart';
import 'package:apartment_managage/domain/models/service/price_list.dart';
import 'package:apartment_managage/domain/models/service/schedule_booking.dart';
import 'package:apartment_managage/utils/utils.dart';

import './enum_service.dart';

class BookingService extends Equatable {
  final String? id;
  final String? userId;
  final String? userName;
  final String typeOrder = 'service';
  final InforContactModel? inforContact;
  final ServiceType? serviceType;
  final String? serviceId;
  final String? serviceName;
  final PriceType? servicePriceType;
  final PriceListItem? servicePriceItem;
  final num? servicePriceBase;
  final String? providerId;
  final String? providerName;
  final ScheduleBooking? schedule;
  final BookingStatus? status;
  final String? note;
  final DateTime? createdAt;
  final String? createdBy;
  final DateTime? updatedAt;
  final String? updatedBy;
  final DateTime? workDate;

  num get total {
    if (serviceType == null) return 0;
    num basecost = 0;
    if (servicePriceType == PriceType.package ||
        servicePriceType == PriceType.hourly) {
      basecost = servicePriceItem?.price ?? 0;
    } else {
      basecost = servicePriceBase ?? 0;
    }
    basecost = basecost * (schedule?.scheduleCount ?? 1);
    return basecost;
  }

  const BookingService({
    this.id,
    this.userId,
    this.userName,
    this.inforContact,
    this.serviceType,
    this.serviceId,
    this.serviceName,
    this.servicePriceType,
    this.servicePriceItem,
    this.servicePriceBase,
    this.providerId,
    this.providerName,
    this.status,
    this.schedule,
    this.note,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.workDate,
  });

  factory BookingService.fromJson(Map<String, dynamic> json) {
    return BookingService(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      inforContact: json['inforContact'] != null
          ? InforContactModel.fromJson(json['inforContact'])
          : null,
      serviceType: json['serviceType'] != null
          ? ServiceType.fromJson(json['serviceType'])
          : null,
      serviceId: json['serviceId'],
      serviceName: json['serviceName'],
      servicePriceType: json['servicePriceType'] != null
          ? PriceType.fromJson(json['servicePriceType'])
          : null,
      servicePriceItem: json['servicePriceItem'] != null
          ? PriceListItem.fromJson(json['servicePriceItem'])
          : null,
      servicePriceBase: json['c'],
      providerId: json['providerId'],
      providerName: json['providerName'],
      status: json['status'] != null
          ? BookingStatus.fromJson(json['status'])
          : BookingStatus.pending,
      schedule: json['schedule'] != null
          ? ScheduleBooking.fromJson(json['schedule'])
          : null,
      note: json['note'],
      createdAt: TextFormat.parseJson(json['createdAt']),
      createdBy: json['createdBy'],
      updatedAt: TextFormat.parseJson(json['updatedAt']),
      updatedBy: json['updatedBy'],
      workDate: json['workDate'],
    );
  }

  factory BookingService.fromDocumentSnapshot(DocumentSnapshot doc) {
    return BookingService.fromJson(doc.data() as Map<String, dynamic>).copyWith(
      id: doc.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'typeOrder': 'service', // 'service
      if (id != null) 'id': id,
      if (userId != null) 'userId': userId,
      if (userName != null) 'userName': userName,
      if (inforContact != null) 'inforContact': inforContact?.toJson(),
      if (serviceType != null) 'serviceType': serviceType?.toJson(),
      if (serviceId != null) 'serviceId': serviceId,
      if (serviceName != null) 'serviceName': serviceName,
      if (servicePriceType != null)
        'servicePriceType': servicePriceType?.toJson(),
      if (servicePriceItem != null)
        'servicePriceItem': servicePriceItem?.toJson(),
      if (servicePriceBase != null) 'servicePriceBase': servicePriceBase,
      if (providerId != null) 'providerId': providerId,
      if (providerName != null) 'providerName': providerName,
      if (status != null) 'status': status?.toJson(),
      if (schedule != null) 'schedule': schedule?.toJson(),
      if (note != null) 'note': note,
      if (createdAt != null) 'createdAt': createdAt,
      if (createdBy != null) 'createdBy': createdBy,
      if (updatedAt != null) 'updatedAt': updatedAt,
      if (updatedBy != null) 'updatedBy': updatedBy,
      if (workDate != null) 'workDate': workDate,
    };
  }

  BookingService copyWith({
    String? id,
    String? userId,
    String? userName,
    InforContactModel? inforContact,
    ServiceType? type,
    String? serviceId,
    String? serviceName,
    PriceType? servicePriceType,
    PriceListItem? servicePriceItem,
    num? servicePriceBase,
    String? providerId,
    String? providerName,
    BookingStatus? status,
    ScheduleBooking? schedule,
    String? note,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
    DateTime? workDate,
  }) {
    return BookingService(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      inforContact: inforContact ?? this.inforContact,
      serviceType: type ?? this.serviceType,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      servicePriceType: servicePriceType ?? this.servicePriceType,
      servicePriceItem: servicePriceItem ?? this.servicePriceItem,
      servicePriceBase: servicePriceBase ?? this.servicePriceBase,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      status: status ?? this.status,
      schedule: schedule ?? this.schedule,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      workDate: workDate ?? this.workDate,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        inforContact,
        serviceId,
        serviceName,
        servicePriceItem,
        servicePriceBase,
        providerId,
        providerName,
        status,
        schedule,
        note,
      ];
}
