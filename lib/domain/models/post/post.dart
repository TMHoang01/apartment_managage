import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:apartment_managage/utils/text_format.dart';

enum PostType {
  event,
  news,
  other;

  String toJson() => name;
  static PostType fromJson(String json) => values.byName(json);
  String toName() {
    switch (this) {
      case PostType.event:
        return 'Sự kiện';
      case PostType.news:
        return 'Tin tức';
      case PostType.other:
        return 'Bài viết';
      default:
        return '';
    }
  }
}

class PostModel extends Equatable {
  final String? id;
  final PostType? type;
  final String? title;
  final String? content;
  final String? image;
  final DateTime? createdAt;
  final String? createdBy;
  final DateTime? updatedAt;
  final String? updatedBy;
  final String? status;

  String get typeString => type?.toName() ?? '';

  PostModel({
    this.id,
    this.type,
    this.title,
    this.content,
    this.image,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.status,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      type: json['type'] != null ? PostType.fromJson(json['type']) : null,
      title: json['title'],
      content: json['content'],
      image: json['image'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      createdAt: TextFormat.parseJson(json['createdAt']) ?? DateTime.now(),
      updatedAt: TextFormat.parseJson(json['updatedAt']) ?? DateTime.now(),
      status: json['status'],
    );
  }

  factory PostModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return PostModel.fromJson(doc.data() as Map<String, dynamic>)
        .copyWith(id: doc.id);
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (type != null) 'type': type?.toJson(),
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (image != null) 'image': image,
      if (createdBy != null) 'createdBy': createdBy,
      if (updatedBy != null) 'updatedBy': updatedBy,
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
      if (status != null) 'status': status,
    };
  }

  PostModel copyWith({
    String? id,
    PostType? type,
    String? title,
    String? content,
    String? image,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
    String? status,
  }) {
    return PostModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      content: content ?? this.content,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [id, type, title, content, image, createdAt, createdBy, updatedAt];
}
