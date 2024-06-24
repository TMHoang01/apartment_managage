import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Permission extends Equatable {
  final String id;
  final String name;

  const Permission({
    required this.id,
    required this.name,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['id'],
      name: json['name'],
    );
  }

  factory Permission.fromSnapshot(DocumentSnapshot doc) {
    return Permission(
      id: doc.id,
      name: doc['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  Permission copyWith({
    String? id,
    String? name,
  }) {
    return Permission(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [id, name];
}

class Position extends Equatable {
  final String? id;
  final String? name;
  final String? description;
  final List<Permission>? permissions;

  const Position({
    this.id,
    this.name,
    this.description,
    this.permissions,
  });

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      permissions: json['permissions'] != null
          ? json['permissions']
              .map<Permission>((e) => Permission.fromJson(e))
              .toList()
          : [],
    );
  }

  factory Position.fromSnapshot(DocumentSnapshot doc) {
    return Position.fromJson(doc.data() as Map<String, dynamic>)
        .copyWith(id: doc.id);
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (permissions != null)
        'permissions': permissions?.map((e) => e.toJson()).toList(),
    };
  }

  Position copyWith({
    String? id,
    String? name,
    String? description,
    List<Permission>? permissions,
  }) {
    return Position(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      permissions: permissions ?? this.permissions,
    );
  }

  @override
  List<Object?> get props => [id];
}

const listPosition = [
  // Position(
  //   id: 'ADMIN',
  //   name: 'Admin',
  //   description: 'Quản trị viên',
  //   permissions: [
  //     Permission(
  //       id: 'SYSTEM',
  //       name: 'Quản trị hệ thống',
  //     ),
  //   ],
  // ),
  Position(
    id: 'MANAGER',
    name: 'Quản lý',
  ),
  Position(
    id: 'RECEPTIONIST',
    name: 'Nhân viên lễ tân',
    description: 'Nhân viên lễ tân',
    permissions: [
      Permission(
        id: 'M_EMPLOYEE',
        name: 'Quản trị nhân viên',
      ),
      Permission(
        id: 'M_CUSTOMER',
        name: 'Quản trị khách hàng',
      ),
    ],
  ),
  Position(
    id: 'GUARD',
    name: 'nhân viên bảo vệ',
  ),
  Position(
    id: 'CLEANER',
    name: 'Nhân viên vệ sinh',
  ),
  Position(
    id: 'ACCOUNTANT',
    name: 'Nhân viên kế toán',
  ),
  Position(
    id: 'TECHNICIAN',
    name: 'Kỹ thuật viên',
  ),
  Position(
    id: 'SALE',
    name: 'Nhân viên bán hàng',
  ),
  Position(
    id: 'STAFF',
    name: 'Nhân viên',
  ),
];
