import 'package:apartment_managage/domain/models/ecom/infor_contact.dart';
import 'package:apartment_managage/domain/models/service/booking_service.dart';
import 'package:apartment_managage/domain/models/service/enum_service.dart';
import 'package:apartment_managage/domain/models/service/price_list.dart';
import 'package:apartment_managage/domain/models/service/schedule_booking.dart';

class BookingServiceChildCare extends BookingService {
  final int? childNumber;
  final String? childAge;
  final String? childGender;
  final int? timeShift;

  @override
  const BookingServiceChildCare({
    super.id,
    super.inforContact,
    super.serviceType,
    super.serviceId,
    super.serviceName,
    super.servicePriceType,
    super.servicePriceItem,
    super.servicePriceBase,
    super.providerId,
    super.providerName,
    super.status,
    super.schedule,
    super.note,
    super.createdAt,
    super.createdBy,
    super.updatedAt,
    super.updatedBy,
    super.workDate,
    this.childNumber,
    this.childAge,
    this.childGender,
    this.timeShift,
  });

  @override
  factory BookingServiceChildCare.fromJson(Map<String, dynamic> json) {
    return BookingServiceChildCare(
      id: json['id'],
      inforContact: json['inforContact'] != null
          ? InforContactModel.fromJson(json['inforContact'])
          : null,
      serviceType:
          json['type'] != null ? ServiceType.fromJson(json['type']) : null,
      serviceId: json['serviceId'],
      serviceName: json['serviceName'],
      servicePriceBase: json['servicePriceBase'],
      providerId: json['providerId'],
      providerName: json['providerName'],
      status: json['status'] != null
          ? BookingStatus.fromJson(json['status'])
          : null,
      schedule: json['schedule'] != null
          ? ScheduleBooking.fromJson(json['schedule'])
          : null,
      note: json['note'],
      createdAt: json['createdAt'],
      createdBy: json['createdBy'],
      updatedAt: json['updatedAt'],
      updatedBy: json['updatedBy'],
      workDate: json['workDate'],
      // child care
      childNumber: json['childNumber'],
      childAge: json['childAge'],
      childGender: json['childGender'],
      timeShift: json['timeShift'],
    );
  }

  @override
  factory BookingServiceChildCare.fromBookingService(
      BookingService bookingService) {
    return BookingServiceChildCare(
      id: bookingService.id,
      inforContact: bookingService.inforContact,
      serviceType: bookingService.serviceType,
      serviceId: bookingService.serviceId,
      serviceName: bookingService.serviceName,
      servicePriceType: bookingService.servicePriceType,
      servicePriceItem: bookingService.servicePriceItem,
      servicePriceBase: bookingService.servicePriceBase,
      providerId: bookingService.providerId,
      providerName: bookingService.providerName,
      status: bookingService.status,
      schedule: bookingService.schedule,
      note: bookingService.note,
      createdAt: bookingService.createdAt,
      createdBy: bookingService.createdBy,
      updatedAt: bookingService.updatedAt,
      updatedBy: bookingService.updatedBy,
      workDate: bookingService.workDate,
    );
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      // child care
      if (childNumber != null) 'childNumber': childNumber,
      if (childAge != null) 'childAge': childAge,
      if (childGender != null) 'childGender': childGender,
      if (timeShift != null) 'timeShift': timeShift,
    };
  }

  @override
  BookingServiceChildCare copyWith({
    String? id,
    String? userId,
    String? userName,
    InforContactModel? inforContact,
    ServiceType? type,
    String? serviceId,
    String? serviceName,
    String? serviceImage,
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
    // child care
    int? childNumber,
    String? childAge,
    String? childGender,
    int? timeShift,
  }) {
    return BookingServiceChildCare(
      id: id ?? this.id,
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
      // child care
      childNumber: childNumber ?? this.childNumber,
      childAge: childAge ?? this.childAge,
      childGender: childGender ?? this.childGender,
      timeShift: timeShift ?? this.timeShift,
    );
  }
}
