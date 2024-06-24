import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PriceListItem extends Equatable {
  final String? id;
  final String? name;
  final num? price;
  final String? note;

  PriceListItem({
    this.id,
    this.name,
    this.price,
    this.note,
  });

  factory PriceListItem.fromJson(Map<String, dynamic> json) {
    return PriceListItem(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      note: json['note'],
    );
  }

  factory PriceListItem.fromDocumentSnapshot(DocumentSnapshot doc) {
    return PriceListItem.fromJson(doc.data() as Map<String, dynamic>).copyWith(
      id: doc.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (price != null) 'price': price,
      if (note != null) 'note': note,
    };
  }

  PriceListItem copyWith({
    String? id,
    String? name,
    num? price,
    String? note,
  }) {
    return PriceListItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props => [id, name, price];
}
