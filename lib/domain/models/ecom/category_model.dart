import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String? id;
  late String? userCreated;
  late int? timeCreated;
  final String? title;
  late String? image;

  Category({
    required this.id,
    required this.title,
    // required this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'],
      // image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
    };
  }

  factory Category.fromDocumentSnapshot(DocumentSnapshot doc) {
    if (doc.exists) {
      return Category(
        id: doc.id,
        title: doc['title'] ?? '',
        // image: doc['image'] ?? '',
      );
    }
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Category(
      id: doc.id,
      title: data['title'] ?? '',
      // image: data['image'] ?? '',
    );
  }
}
