import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apartment_managage/domain/models/post/post.dart';
import 'package:apartment_managage/utils/text_format.dart';

class NewsModel extends PostModel {
  NewsModel({
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
  }) : super(
            id: id,
            type: PostType.news,
            title: title,
            content: content,
            image: image,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            status: status);

  @override
  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      image: json['image'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      createdAt: TextFormat.parseJson(json['createdAt']),
      updatedAt: TextFormat.parseJson(json['updatedAt']),
      status: json['status'],
    );
  }

  @override
  factory NewsModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return NewsModel.fromJson(doc.data() as Map<String, dynamic>)
        .copyWith(id: doc.id);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
    };
  }

  @override
  NewsModel copyWith({
    String? id,
    String? title,
    String? content,
    String? image,
    PostType? type,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
    String? status,
  }) {
    return NewsModel(
      id: id ?? this.id,
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
}
