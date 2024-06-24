import 'package:apartment_managage/domain/models/service/service_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:apartment_managage/domain/models/service/price_list.dart';
import 'package:apartment_managage/utils/text_format.dart';

import './enum_service.dart';

class ServiceModel extends Equatable {
  final String? id;
  final ServiceType? type;
  final bool? isRecurringSevice;
  final String? providerId;
  final String? providerName;
  final String? title;
  final String? image;
  final String? description;
  final num? priceBase;
  final PriceType? priceType;
  final List<PriceListItem>? priceList;
  final double? rating;
  final Map<int, int>? ratingCount;
  final int? bookingCount;
  final DateTime? createdAt;
  final String? createdBy;
  final DateTime? updatedAt;
  final String? updatedBy;
  final ServiceDetail? serviceDetail;

  const ServiceModel({
    this.id,
    this.type,
    this.image,
    this.isRecurringSevice,
    this.providerId,
    this.providerName,
    this.title,
    this.description,
    this.priceBase,
    this.priceType,
    this.priceList,
    this.rating = 0.0,
    this.ratingCount = const {},
    this.bookingCount = 0,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.serviceDetail,
  });

  get typeNames => type?.toName();
  int get ratingCountTotal {
    int total = 0;
    ratingCount?.forEach((key, value) {
      total += value;
    });
    return total;
  }

  double get ratingAverage {
    if (ratingCountTotal == 0) {
      return 0.0;
    }
    int sum = 0;
    ratingCount?.forEach((key, value) {
      sum += key * value;
    });
    String roundedString = (sum / ratingCountTotal).toStringAsFixed(1);
    double roundedNumber = double.parse(roundedString);

    return roundedNumber;
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    final type = ServiceType.fromJson(json['type']);
    ServiceDetail? serviceDetail;
    if (json['serviceDetail'] != null) {
      switch (type) {
        // case ServiceType.peopleCare:
        //   serviceDetail =
        //       ServiceDetailPeopleCare.fromJson(json['serviceDetail']);
        //   break;

        default:
          serviceDetail = ServiceDetail.fromJson(json['serviceDetail']);
          break;
      }
    }
    return ServiceModel(
      id: json['id'],
      type: type,
      image: json['image'],
      isRecurringSevice: json['isRecurringSevice'],
      providerId: json['providerId'],
      providerName: json['providerName'],
      title: json['title'],
      description: json['description'],
      priceBase: json['priceBase'],
      priceType: json['priceType'] != null
          ? PriceType.fromJson(json['priceType'])
          : null,
      priceList: json['priceList'] != null
          ? List<PriceListItem>.from(
              json['priceList'].map((x) => PriceListItem.fromJson(x)))
          : [],
      rating: json['rating'].toDouble() ?? 0.0,
      ratingCount: json['ratingCount'] != null
          ? _parseRatingCount(Map<String, dynamic>.from(json['ratingCount']))
          : null,
      bookingCount: json['bookingCount'] ?? 0,
      createdAt: TextFormat.parseJson(json['createdAt']) ?? DateTime.now(),
      createdBy: json['createdBy'],
      updatedAt: TextFormat.parseJson(json['updatedAt']) ?? DateTime.now(),
      updatedBy: json['updatedBy'],
      serviceDetail: serviceDetail,
    );
  }

  factory ServiceModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return ServiceModel.fromJson(doc.data() as Map<String, dynamic>).copyWith(
      id: doc.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (type != null) 'type': type?.toJson(),
      if (image != null) 'image': image,
      if (isRecurringSevice != null) 'isRecurringSevice': isRecurringSevice,
      if (providerId != null) 'providerId': providerId,
      if (providerName != null) 'providerName': providerName,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (priceBase != null) 'priceBase': priceBase,
      if (priceType != null) 'priceType': priceType?.toJson(),
      if (priceList != null)
        'priceList': priceList?.map((x) => x.toJson()).toList(),
      if (rating != null) 'rating': rating,
      if (ratingCount != null) 'ratingCount': ratingCount,
      if (bookingCount != null) 'bookingCount': bookingCount,
      if (createdAt != null) 'createdAt': createdAt,
      if (createdBy != null) 'createdBy': createdBy,
      if (updatedAt != null) 'updatedAt': updatedAt,
      if (updatedBy != null) 'updatedBy': updatedBy,
      if (serviceDetail != null) 'serviceDetail': serviceDetail?.toJson(),
    };
  }

  static Map<int, int> _parseRatingCount(Map<String, dynamic> json) {
    final ratingCountMap = <int, int>{};
    json.forEach((key, value) {
      ratingCountMap[int.parse(key)] = value;
    });
    return ratingCountMap;
  }

  ServiceModel copyWith({
    String? id,
    ServiceType? type,
    String? image,
    bool? isRecurringSevice,
    String? providerId,
    String? providerName,
    String? title,
    String? description,
    num? priceBase,
    PriceType? priceType,
    List<PriceListItem>? priceList,
    double? rating,
    Map<int, int>? ratingCount,
    int? bookingCount,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
    ServiceDetail? serviceDetail,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      type: type ?? this.type,
      image: image ?? this.image,
      isRecurringSevice: isRecurringSevice ?? this.isRecurringSevice,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      title: title ?? this.title,
      description: description ?? this.description,
      priceBase: priceBase ?? this.priceBase,
      priceType: priceType ?? this.priceType,
      priceList: priceList ?? this.priceList,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      bookingCount: bookingCount ?? this.bookingCount,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      serviceDetail: serviceDetail ?? this.serviceDetail,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        image,
        isRecurringSevice,
        providerId,
        providerName,
        title,
        description,
        priceBase,
        priceType,
        priceList,
        rating,
        ratingCount,
        bookingCount,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        serviceDetail,
      ];
}
