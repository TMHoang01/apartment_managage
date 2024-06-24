import 'package:equatable/equatable.dart';

class ShopModel extends Equatable {
  final String id;
  final String name;
  final String ownerId;

  const ShopModel({
    required this.id,
    required this.name,
    required this.ownerId,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: json['id'],
      name: json['name'],
      ownerId: json['ownerId'],
    );
  }

  @override
  List<Object?> get props => [id, name, ownerId];
}
