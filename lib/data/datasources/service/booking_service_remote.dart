import 'package:apartment_managage/domain/models/service/booking_service.dart';
import 'package:apartment_managage/domain/models/service/enum_service.dart';
import 'package:apartment_managage/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BookingServiceRemoteDataSource {
  Future<BookingService?> add({required BookingService booking});
  Future<void> update({required BookingService booking});
  Future<void> delete({required String id});

  Future<List<BookingService>> getAll();

  Future<List<BookingService>> getScheduleInDay(String date);

  Future<void> updateStatus(
      {required String id, required BookingStatus status});

  Future<List<BookingService>> getAllByUserId({required String userId});
}

class BookingServiceRemoteDataSourceImpl
    implements BookingServiceRemoteDataSource {
  final colection = orderRef;
  @override
  Future<BookingService?> add({required BookingService booking}) async {
    try {
      final createAt = FieldValue.serverTimestamp();
      final json = booking.toJson();
      json['createdAt'] = createAt;
      final response = await colection.add(json);
      return booking.copyWith(id: response.id);
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> delete({required String id}) {
    throw UnimplementedError();
  }

  @override
  Future<List<BookingService>> getAll() async {
    try {
      final response =
          await colection.orderBy('createdAt', descending: true).get();
      final list = response.docs
          .map((e) => BookingService.fromDocumentSnapshot(e))
          .toList();
      return list;
    } on FirebaseException catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> update({required BookingService booking}) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<List<BookingService>> getScheduleInDay(String date) async {
    // flitter array scheduleDates date >= date && date < nextDay
    try {
      final firestore = FirebaseFirestore.instance;
      final response = await firestore
          .collection("orders")
          .where("schedule.scheduleDates", arrayContains: date)
          //     .where("status", whereIn: [
          //   BookingStatus.accepted.toJson(),
          //   BookingStatus.completed.toJson()
          // ])
          .get();
      final list = response.docs
          .map((e) => BookingService.fromJson(e.data() as Map<String, dynamic>))
          .toList();

      return list;
    } on FirebaseException catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> updateStatus(
      {required String id, required BookingStatus status}) async {
    try {
      await colection.doc(id).set({
        'status': status.toJson(),
      }, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<BookingService>> getAllByUserId({required String userId}) async {
    try {
      final response = await colection
          .where('createdBy', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      final list = response.docs
          .map((e) => BookingService.fromDocumentSnapshot(e))
          .toList();
      return list;
    } on FirebaseException catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }
}
