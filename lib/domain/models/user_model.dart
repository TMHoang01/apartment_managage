import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apartment_managage/utils/utils.dart';

enum Role {
  admin,
  employee,
  user,
  provider,
  resident;

  String toJson() => name;
  static Role fromJson(String json) => values.byName(json);
}

enum StatusUser {
  active,
  rejected,
  pending,
  locked;

  String toJson() => name;
  static StatusUser fromJson(String json) => values.byName(json);
}

class UserModel {
  final String? id;
  final String? email;
  final String? phone;
  final String? address;
  final DateTime? createdAt;
  final Role? roles;
  final String? avatar;
  final String? username;
  final StatusUser? status;
  // Role.resident
  final DateTime? birthDay;
  final String? job;
  // Role.provider
  final String? description;
  // final
  UserModel({
    this.username,
    this.email,
    this.phone,
    this.job,
    this.address,
    this.birthDay,
    this.createdAt,
    this.roles,
    this.id,
    this.description,
    this.avatar,
    this.status,
  });
  String get uid => id ?? '';
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      createdAt: TextFormat.parseJson(json['created_at']),
      roles: json['roles'] != null ? Role.fromJson(json['roles']) : null,
      description: json['bio'],
      avatar: json['avatar'],
      status:
          json['status'] != null ? StatusUser.fromJson(json['status']) : null,

      // Role.resident
      job: json['job'],
      birthDay: TextFormat.parseJson(json['birthDay']),
      // Role.provider
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (email != null) 'email': email,
      if (createdAt != null) 'created_at': createdAt,
      if (roles != null) 'roles': roles?.toJson(),
      if (avatar != null) 'avatar': avatar,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (status != null) 'status': status?.toJson(),

      // Role.resident
      if (job != null) 'job': job,
      if (birthDay != null) 'birthDay': birthDay,
      // Role.provider
      if (description != null) 'bio': description,
    };
  }

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel.fromJson(data).copyWith(id: doc.id);
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? phone,
    String? job,
    String? address,
    DateTime? birthDay,
    DateTime? createdAt,
    Role? roles,
    String? description,
    String? avatar,
    StatusUser? status,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      roles: roles ?? this.roles,
      description: description ?? this.description,
      avatar: avatar ?? this.avatar,
      address: address ?? this.address,
      job: job ?? this.job,
      birthDay: birthDay ?? this.birthDay,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'UserModel(username: $username, email: $email, roles: $roles)';
  }
}
