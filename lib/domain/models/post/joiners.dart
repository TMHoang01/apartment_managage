import 'package:equatable/equatable.dart';

class JoinersModel extends Equatable {
  final String id;
  final String name;
  final String? email;
  final String avatar;

  const JoinersModel({
    required this.id,
    required this.name,
    this.email,
    required this.avatar,
  });

  factory JoinersModel.fromJson(Map<String, dynamic> json) {
    return JoinersModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
    };
  }

  @override
  List<Object?> get props => [id, name, email, avatar];
}
