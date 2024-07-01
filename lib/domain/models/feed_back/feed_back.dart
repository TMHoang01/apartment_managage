import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:apartment_managage/domain/models/manage/employee.dart';
import 'package:apartment_managage/utils/utils.dart';

// cách loiaj feedbak như về dịch vụ. cư dân, trang thiết bị, vệ sinh, an ninh
enum FeedBackType {
  service,
  provider,
  equipment,
  security,
  hygiene,
  orther;

  String toJson() => name;
  static FeedBackType fromJson(String json) => values.byName(json);

  String toName() {
    switch (this) {
      case FeedBackType.service:
        return 'Dịch vụ';
      case FeedBackType.provider:
        return 'Nhà cung cấp';
      case FeedBackType.equipment:
        return 'Trang thiết bị';
      case FeedBackType.security:
        return 'An ninh';
      case FeedBackType.hygiene:
        return 'Vệ sinh';
      case FeedBackType.orther:
        return 'Khác';
    }
  }
}

enum FeedBackStatus {
  pending,
  approved,
  completed,
  reviewed;

  String toJson() => name;
  static FeedBackStatus fromJson(String? json) =>
      values.byName(json ?? 'pending');

  String toName() {
    switch (this) {
      case FeedBackStatus.pending:
        return 'Chờ duyệt';
      case FeedBackStatus.approved:
        return 'Đăng xử lý';
      case FeedBackStatus.completed:
        return 'Hoàn thành';
      case FeedBackStatus.reviewed:
        return 'Đã đánh giá';
      default:
        return 'Chờ duyệt';
    }
  }
}

class FeedBackModel extends Equatable {
  final String? id;
  final String? userId;
  final String? userName;
  final FeedBackType? type;
  final String? image;
  final String? content;
  final FeedBackStatus? status;
  final List<Employee>? listHandlers;
  final double? rating;
  final String? review;
  final DateTime? createdAt;
  final String? createdBy;
  final DateTime? updatedAt;
  final String? updatedBy;

  const FeedBackModel({
    this.id,
    this.userId,
    this.userName,
    this.type,
    this.image,
    this.content,
    this.status,
    this.listHandlers,
    this.rating,
    this.review,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  factory FeedBackModel.fromJson(Map<String, dynamic> json) {
    return FeedBackModel(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      image: json['image'],
      type: FeedBackType.fromJson(json['type']),
      content: json['content'],
      status: FeedBackStatus.fromJson(json['status']),
      listHandlers: json['listHandlers'] != null
          ? List<Employee>.from(
              json['listHandlers'].map((x) => Employee.fromJson(x)))
          : List<Employee>.empty(),
      rating: json['rating'],
      review: json['review'],
      createdAt: TextFormat.parseJson(json['createdAt']),
      createdBy: json['createdBy'],
      updatedAt: TextFormat.parseJson(json['updatedAt']),
      updatedBy: json['updatedBy'],
    );
  }

  factory FeedBackModel.fromSnapshot(DocumentSnapshot doc) {
    return FeedBackModel.fromJson(doc.data() as Map<String, dynamic>).copyWith(
      id: doc.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (userId != null) 'userId': userId,
      if (userName != null) 'userName': userName,
      if (type != null) 'type': type?.toJson(),
      if (image != null) 'image': image,
      if (content != null) 'content': content,
      if (status != null) 'status': status?.toJson(),
      if (listHandlers != null)
        'listHandlers': listHandlers?.map((x) => x.toJsonInfor()).toList(),
      if (rating != null) 'rating': rating,
      if (review != null) 'review': review,
      if (createdAt != null) 'createdAt': createdAt,
      if (createdBy != null) 'createdBy': createdBy,
      if (updatedAt != null) 'updatedAt': updatedAt,
      if (updatedBy != null) 'updatedBy': updatedBy,
    };
  }

  String jsEncode() {
    return jsonEncode({
      if (id != null) 'id': id,
      if (userId != null) 'userId': userId,
      if (userName != null) 'userName': userName,
      if (type != null) 'type': type?.toJson(),
      if (image != null) 'image': image,
      if (content != null) 'content': content,
      if (status != null) 'status': status?.toJson(),
      if (listHandlers != null)
        'listHandlers': listHandlers?.map((x) => x.toJsonInfor()).toList(),
      if (rating != null) 'rating': rating,
      if (review != null) 'review': review,
      if (createdAt != null) 'createdAt': createdAt?.toIso8601String(),
      if (createdBy != null) 'createdBy': createdBy,
      if (updatedAt != null) 'updatedAt': updatedAt?.toIso8601String(),
      if (updatedBy != null) 'updatedBy': updatedBy,
    });
  }

  FeedBackModel copyWith({
    String? id,
    String? userId,
    String? userName,
    FeedBackType? type,
    String? image,
    String? content,
    FeedBackStatus? status,
    List<Employee>? listHandlers,
    double? rating,
    String? review,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
  }) {
    return FeedBackModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      image: image ?? this.image,
      type: type ?? this.type,
      content: content ?? this.content,
      status: status ?? this.status,
      listHandlers: listHandlers ?? this.listHandlers,
      rating: rating ?? this.rating,
      review: review ?? this.review,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        content,
        type,
        image,
        status,
        listHandlers,
        rating,
        review,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
      ];
}
