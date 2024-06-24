import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apartment_managage/domain/models/post/joiners.dart';
import 'package:apartment_managage/domain/models/post/post.dart';
import 'package:apartment_managage/utils/text_format.dart';

enum EventType {
  public,
  private,
  privateInvite,
}

class EventModel extends PostModel {
  final int? joinersCount;
  final String? location;
  final DateTime? beginDate;
  final DateTime? endDate;
  final bool? limitJoiners;
  final int? maxJoiners;
  final List<String>? joinerIds;
  final List<JoinersModel>? joiners;
  final List<JoinersModel>? organizers;
  final bool? isPublic;
  final bool? allowInvite;
  final bool? organizersOnlyCanInvite;

  EventModel({
    this.joinersCount,
    this.location,
    this.beginDate,
    this.endDate,
    this.limitJoiners,
    this.maxJoiners,
    this.joinerIds,
    this.joiners,
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
    this.organizers,
    this.isPublic = true,
    this.allowInvite = true,
    this.organizersOnlyCanInvite = false,
  }) : super(
            id: id,
            type: PostType.event,
            title: title,
            content: content,
            image: image,
            createdAt: createdAt,
            createdBy: createdBy,
            updatedAt: updatedAt,
            updatedBy: updatedBy,
            status: status);

  @override
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      image: json['image'] as String?,
      type: json['type'] != null ? PostType.fromJson(json['type']) : null,
      createdAt: TextFormat.parseJson(json['createdAt']),
      createdBy: json['createdBy'] as String?,
      updatedAt: TextFormat.parseJson(json['updatedAt']),
      updatedBy: json['updatedBy'] as String?,
      status: json['status'] as String?,
      joinersCount: json['joinersCount'] as int?,
      location: json['location'] as String?,
      beginDate: TextFormat.parseJson(json['beginDate']),
      endDate: TextFormat.parseJson(json['endDate']),
      limitJoiners: json['limitJoiners'] as bool?,
      maxJoiners: json['maxJoiners'] as int?,
      joinerIds: (json['joinerIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      joiners: (json['joiners'] as List<dynamic>?)
          ?.map((e) => JoinersModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      organizers: (json['organizers'] as List<dynamic>?)
          ?.map((e) => JoinersModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isPublic: json['isPublic'] as bool?,
      organizersOnlyCanInvite: json['organizersOnlyCanInvite'] as bool?,
    );
  }

  @override
  factory EventModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final json = doc.data() as Map<String, dynamic>;
    return EventModel.fromJson(json).copyWith(id: doc.id);
  }

  @override
  EventModel copyWith({
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
    // EventModel
    int? joinersCount,
    String? location,
    DateTime? beginDate,
    DateTime? endDate,
    bool? limitJoiners,
    int? maxJoiners,
    List<String>? joinerIds,
    List<JoinersModel>? joiners,
    List<JoinersModel>? organizers,
    bool? isPublic,
    bool? allowInvite,
    bool? organizersOnlyCanInvite,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      image: image ?? this.image,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      status: status ?? this.status,
      joinersCount: joinersCount ?? this.joinersCount,
      location: location ?? this.location,
      beginDate: beginDate ?? this.beginDate,
      endDate: endDate ?? this.endDate,
      limitJoiners: limitJoiners ?? this.limitJoiners,
      maxJoiners: maxJoiners ?? this.maxJoiners,
      joinerIds: joinerIds ?? this.joinerIds,
      joiners: joiners ?? this.joiners,
      organizers: organizers ?? this.organizers,
      isPublic: isPublic ?? this.isPublic,
      allowInvite: allowInvite ?? this.allowInvite,
      organizersOnlyCanInvite:
          organizersOnlyCanInvite ?? this.organizersOnlyCanInvite,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = {
      ...super.toJson(),
      if (joinersCount != null) 'joinersCount': joinersCount,
      if (location != null) 'location': location,
      if (beginDate != null) 'beginDate': beginDate,
      if (endDate != null) 'endDate': endDate,
      if (limitJoiners != null) 'limitJoiners': limitJoiners,
      if (maxJoiners != null) 'maxJoiners': maxJoiners,
      if (joiners != null) 'joiners': joiners?.map((e) => e.toJson()).toList(),
      if (organizers != null)
        'organizers': organizers?.map((e) => e.toJson()).toList(),
      if (isPublic != null) 'isPublic': isPublic,
      if (allowInvite != null) 'allowInvite': allowInvite,
      if (organizersOnlyCanInvite != null)
        'organizersOnlyCanInvite': organizersOnlyCanInvite,
    };
    return json;
  }

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        image,
        createdAt,
        createdBy,
        updatedAt,
        updatedBy,
        status,
        joinersCount,
        location,
        beginDate,
        endDate,
        limitJoiners,
        maxJoiners,
        joiners,
        organizers,
        isPublic,
        allowInvite,
        organizersOnlyCanInvite,
      ];
}
