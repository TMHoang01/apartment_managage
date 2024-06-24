import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:apartment_managage/domain/models/ecom/cart_item.dart';

class CartModel extends Equatable {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double total;
  final String? status;
  final DateTime createdAt;

  const CartModel({
    this.id = '',
    required this.userId,
    required this.items,
    this.total = 0.0,
    this.status,
    required this.createdAt,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    try {
      return CartModel(
        id: json['id'] ?? '',
        userId: json['userId'] ?? '',
        items: json['items']
            .map<CartItem>((item) => CartItem.fromJson(item))
            .toList(),
        total: json['total'] ?? 0.0,
        status: json['status'] ?? 'pending',
        createdAt: json["create_at"] != null
            ? (json["create_at"] as Timestamp).toDate()
            : DateTime.now(),
      );
    } catch (e) {
      print(e);
    }
    return CartModel.empty('');
  }

  factory CartModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return CartModel.fromJson(doc.data() as Map<String, dynamic>).copyWith(
      id: doc.id,
    );
  }

  factory CartModel.empty(String userId) {
    return CartModel(
      userId: userId,
      items: const [],
      total: 0.0,
      status: 'pending',
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items,
      'total': total,
      'status': status,
      'created_at': createdAt,
    };
  }

  CartModel copyWith({
    String? id,
    String? userId,
    List<CartItem>? items,
    double? total,
    String? status,
    DateTime? createdAt,
  }) {
    return CartModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? [...this.items],
      total: total ?? this.total,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, userId, items, total, status, createdAt];

  double get totalAmount {
    return items.fold(0, (total, item) => total + item.price * item.quantity);
  }
}
