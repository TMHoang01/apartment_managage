import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apartment_managage/domain/models/manage/position.dart';
import 'package:apartment_managage/domain/models/user_model.dart';
import 'package:apartment_managage/utils/utils.dart';

class Employee extends UserModel {
  final String? employeeId;
  final Position? position;
  final String? defaultPassword;

  @override
  Employee({
    super.id,
    super.username,
    super.birthDay,
    super.email,
    super.phone,
    super.address,
    super.avatar,
    super.roles,
    super.status,
    super.createdAt,
    super.job,
    this.employeeId,
    this.position,
    this.defaultPassword,
  });

  @override
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      username: json['username'],
      birthDay: TextFormat.parseJson(json['birthDay']),
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      avatar: json['avatar'],
      roles: json['roles'] != null ? Role.fromJson(json['roles']) : null,
      status:
          json['status'] != null ? StatusUser.fromJson(json['status']) : null,
      createdAt: TextFormat.parseJson(json['createdAt']),
      job: json['job'],
      position:
          json['position'] != null ? Position.fromJson(json['position']) : null,
      defaultPassword: json['defaultPassword'],
    );
  }

  @override
  factory Employee.fromSnapshot(DocumentSnapshot doc) {
    return Employee.fromJson(doc.data() as Map<String, dynamic>).copyWith(
      id: doc.id,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      if (employeeId != null) 'employeeId': employeeId,
      if (position != null) 'position': position?.toJson(),
      if (defaultPassword != null) 'defaultPassword': defaultPassword,
    };
  }

  Map<String, dynamic> toJsonInfor() {
    return {
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (email != null) 'email': email,
      if (avatar != null) 'avatar': avatar,
      if (phone != null) 'phone': phone,
      if (employeeId != null) 'employeeId': employeeId,
    };
  }

  @override
  Employee copyWith({
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
    String? employeeId,
    Position? position,
    String? defaultPassword,
  }) {
    return Employee(
      id: id ?? this.id,
      username: username ?? this.username,
      birthDay: birthDay ?? this.birthDay,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      job: job ?? this.job,
      roles: roles ?? this.roles,
      status: status ?? this.status,
      employeeId: employeeId ?? this.employeeId,
      position: position ?? this.position,
      defaultPassword: defaultPassword ?? this.defaultPassword,
    );
  }

  @override
  List<Object?> get props => [
        super.id,
        super.username,
        super.birthDay,
        super.email,
        super.phone,
        super.address,
        super.avatar,
        super.roles,
        super.status,
        super.createdAt,
        super.job,
        employeeId,
        position,
        defaultPassword,
      ];
}
