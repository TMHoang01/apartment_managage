// enum status order
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:apartment_managage/domain/models/ecom/cart_item.dart';
import 'package:apartment_managage/domain/models/ecom/infor_contact.dart';

enum StatusOrder {
  pending,
  onProgress,
  onDelivery,
  delivered,
  canceled,
}

class OrderModel extends Equatable {
  final String? id;
  final String? userId;
  final InforContactModel? address;
  final List<CartItem>? items;
  final double? total;
  final String? note;
  final StatusOrder? status;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderModel({
    this.id,
    this.userId,
    this.address,
    this.items,
    this.total,
    this.note,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['userId'],
      address: json['address'] != null
          ? InforContactModel.fromJson(json['address'])
          : null,
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      total: json['total'],
      status: StatusOrder.values
          .firstWhere((e) => e.toString() == 'StatusOrder.${json['status']}'),
      note: json['note'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'address': address?.toJson(),
      'items': items?.map((item) => item.toJson()).toList(),
      'total': total,
      'status': status.toString().split('.').last,
      'note': note,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory OrderModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return OrderModel.fromJson(doc.data() as Map<String, dynamic>).copyWith(
      id: doc.id,
    );
  }

  OrderModel copyWith({
    String? id,
    String? userId,
    InforContactModel? address,
    List<CartItem>? items,
    double? total,
    StatusOrder? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      address: address ?? this.address,
      items: items ?? this.items,
      total: total ?? this.total,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, userId];
}
