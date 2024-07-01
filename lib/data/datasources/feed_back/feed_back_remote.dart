import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apartment_managage/domain/models/feed_back/feed_back.dart';
import 'package:apartment_managage/sl.dart';
import 'package:apartment_managage/utils/constants.dart';
import 'package:apartment_managage/utils/firebase.dart';
import 'package:apartment_managage/utils/logger.dart';

abstract class FeedBackRemoteDataSource {
  Future<FeedBackModel?> add({required FeedBackModel feedBack});
  Future<void> update({required FeedBackModel feedBack});
  Future<void> delete({required String id});

  Future<List<FeedBackModel>> getAll(
      {DateTime? lastCreateAt,
      DateTime? endCreateAt,
      DateTime? lastUpdated,
      int limit = LIMIT_PAGE,
      Map<String, String>? filter});

  Stream<List<FeedBackModel>> getAllByUserId({required String userId});

  Future<void> changeStatus({String? id, required String status});
}

class FeedBackRemoteDataSourceImpl implements FeedBackRemoteDataSource {
  final db = sl<FirebaseFirestore>();

  @override
  Future<FeedBackModel?> add({required FeedBackModel feedBack}) async {
    try {
      final createAt = FieldValue.serverTimestamp();
      final json = feedBack.toJson();
      json['createdAt'] = createAt;
      final response = await db.collection('feedbacks').add(json);
      return feedBack.copyWith(id: response.id);
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> delete({required String id}) {
    try {
      return db.collection('feedbacks').doc(id).delete();
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<FeedBackModel>> getAll(
      {DateTime? lastCreateAt,
      DateTime? endCreateAt,
      DateTime? lastUpdated,
      int limit = 15,
      Map<String, String>? filter}) async {
    try {
      Query query =
          db.collection('feedbacks').orderBy('createdAt', descending: true);
      if (lastCreateAt != null) {
        query = query.startAfter([lastCreateAt]);
      }
      if (endCreateAt != null) {
        // query = query.endBefore([endCreateAt]);
        query = query.where('createdAt', isGreaterThanOrEqualTo: endCreateAt);
      }
      if (lastUpdated != null) {
        query = query.where('updatedAt', isGreaterThan: lastUpdated);
      }

      if (filter != null) {
        const List<String> fieldKey = ['status', 'type', 'userId'];
        filter.forEach((key, value) {
          if (value.isEmpty) return;
          if (fieldKey.contains(key)) {
            query = query.where(key, isEqualTo: value);
          }
          if (key == 'listHandlers') {
            query = query.where('listHandlers', arrayContains: value);
          }
        });
      }

      final response = query.limit(limit).get();
      return (await response)
          .docs
          .map((e) => FeedBackModel.fromSnapshot(e))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> update({required FeedBackModel feedBack}) {
    try {
      final json = feedBack.toJson();
      json['updatedAt'] = FieldValue.serverTimestamp();
      return db.collection('feedbacks').doc(feedBack.id).update(json);
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Stream<List<FeedBackModel>> getAllByUserId({required String userId}) async* {
    try {
      final response = db
          .collection('feedbacks')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots();
      yield* response.map((event) =>
          event.docs.map((e) => FeedBackModel.fromSnapshot(e)).toList());
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<FeedBackModel>> getFeedBacks(
      {int limit = 10, DocumentSnapshot? lastDocument}) async {
    Query query = FirebaseFirestore.instance
        .collection('feedbacks')
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    QuerySnapshot querySnapshot = await query.get();

    List<FeedBackModel> feedbacks = [];
    querySnapshot.docs.forEach((doc) {
      feedbacks.add(FeedBackModel.fromSnapshot(doc));
    });

    return feedbacks;
  }

  @override
  Future<void> changeStatus({String? id, required String status}) {
    try {
      return db.collection('feedbacks').doc(id).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': userCurrent!.id,
      });
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }
}
