import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class InforContactModel extends Equatable {
  final String? id;
  final String? userId;
  final String? username;
  final String? address;
  final String? phone;

  const InforContactModel(
      {this.id, this.username, this.address, this.phone, this.userId});

  factory InforContactModel.fromJson(Map<String, dynamic> json) {
    return InforContactModel(
      id: json['id'],
      username: json['username'],
      address: json['address'],
      phone: json['phone'],
      userId: json['userId'],
    );
  }

  factory InforContactModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return InforContactModel.fromJson(doc.data() as Map<String, dynamic>)
        .copyWith(
      id: doc.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'address': address,
      'phone': phone,
      'userId': userId,
    };
  }

  InforContactModel copyWith({
    String? id,
    String? userId,
    String? username,
    String? address,
    String? phone,
  }) {
    return InforContactModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      address: address ?? this.address,
      phone: phone ?? this.phone,
    );
  }

  @override
  List<Object?> get props => [id, userId, username, address, phone];
}
