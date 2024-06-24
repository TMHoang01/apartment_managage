import 'package:apartment_managage/presentation/a_features/parking/domain/model/parking_history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apartment_managage/presentation/a_features/parking/domain/model/parking_lot.dart';
import 'package:apartment_managage/utils/utils.dart';

abstract class ParkingRemoteDataSource {
  Future<List<ParkingLot>> getParkingLotsInFloor(String floor);

  Future<ParkingLot> updateParkingLot(ParkingLot parkingLot);

  Future<ParkingHistory> checkIn(ParkingHistory history);
  Future<ParkingHistory> checkOut(ParkingHistory parkingLot);
  Future<List<ParkingHistory>> getParkingHistoryInDate(DateTime date);
  Future<List<ParkingHistory>> getParkingHistoryByVehicleLicensePlate(
      String vehicleLicensePlate);
  Future<List<ParkingHistory>> getParkingHistoryByTicketId(String ticketId);
}

class ParkingRemoteDataSourceImpl implements ParkingRemoteDataSource {
  final storage = FirebaseFirestore.instance;
  final String parking = 'parking';
  final String parkingHistory = 'parkingHistory';

  @override
  Future<List<ParkingLot>> getParkingLotsInFloor(String floor) async {
    try {
      final querySnapshot = await storage
          .collection(parking)
          .where('floor', isEqualTo: floor)
          .get();
      return querySnapshot.docs
          .map((e) => ParkingLot.fromDocumentSnapshot(e))
          .toList();
    } catch (e) {
      logger.e(e);
      throw e;
    }
  }

  @override
  Future<ParkingLot> updateParkingLot(ParkingLot parkingLot) {
    throw UnimplementedError();
  }

  @override
  Future<ParkingHistory> checkIn(ParkingHistory history) async {
    try {
      final doc =
          await storage.collection(parkingHistory).add(history.toJson());
      return history.copyWith(id: doc.id);
    } catch (e) {
      logger.e(e);
      throw e;
    }
  }

  @override
  Future<ParkingHistory> checkOut(ParkingHistory parkingLot) {
    throw UnimplementedError();
  }

  @override
  Future<List<ParkingHistory>> getParkingHistoryInDate(DateTime date) async {
    try {
      final beginDate = DateTime(date.year, date.month, date.day);
      final endDate = DateTime(date.year, date.month, date.day + 1);
      final querySnapshot = await storage
          .collection(parkingHistory)
          .where('timeIn', isGreaterThanOrEqualTo: beginDate)
          .where('timeIn', isLessThan: endDate)
          .get();
      return querySnapshot.docs
          .map((e) => ParkingHistory.fromDocument(e))
          .toList();
    } catch (e) {
      logger.e(e);
      throw e;
    }
  }

  @override
  Future<List<ParkingHistory>> getParkingHistoryByVehicleLicensePlate(
      String vehicleLicensePlate) async {
    try {
      final querySnapshot = await storage
          .collection(parkingHistory)
          .where('vehicleLicensePlate', isEqualTo: vehicleLicensePlate)
          .get();
      return querySnapshot.docs
          .map((e) => ParkingHistory.fromDocument(e))
          .toList();
    } catch (e) {
      logger.e(e);
      throw e;
    }
  }

  @override
  Future<List<ParkingHistory>> getParkingHistoryByTicketId(String ticketId) {
    throw UnimplementedError();
  }
}
