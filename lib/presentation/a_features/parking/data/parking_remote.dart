import 'package:apartment_managage/presentation/a_features/parking/domain/model/parking_checkin.dart';
import 'package:apartment_managage/presentation/a_features/parking/domain/model/vehicle_ticket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apartment_managage/presentation/a_features/parking/domain/model/parking_lot.dart';
import 'package:apartment_managage/utils/utils.dart';

abstract class ParkingRemoteDataSource {
  Future<List<ParkingLot>> getParkingLotsInFloor(String floor);

  Future<ParkingLot> updateParkingLot(ParkingLot parkingLot);

  Future<ParkingCheckIn> checkIn(ParkingCheckIn history);
  Future<ParkingCheckIn> checkOut(ParkingCheckIn parkingLot);
  Future<List<ParkingCheckIn>> getParkingCheckInInDate(DateTime date);
  Future<List<ParkingCheckIn>> getParkingVehicleBySearch(String q);
  Future<List<ParkingCheckIn>> getParkingCheckInByTicketId(String ticketId);
  Future<List<ParkingCheckIn>> getParkingInParkingLot();

  Future<bool> isVehicleInParking(String ticketCode);
}

class ParkingRemoteDataSourceImpl implements ParkingRemoteDataSource {
  final firestore = FirebaseFirestore.instance;
  final String parking = 'parking';
  final String parkingHistory = 'parkingHistory';
  final String vehiclesTicket = 'vehicles';

  @override
  Future<List<ParkingLot>> getParkingLotsInFloor(String floor) async {
    try {
      final querySnapshot = await firestore
          .collection(parking)
          .where('floor', isEqualTo: floor)
          .get();
      return querySnapshot.docs
          .map((e) => ParkingLot.fromDocumentSnapshot(e))
          .toList();
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<ParkingLot> updateParkingLot(ParkingLot parkingLot) {
    throw UnimplementedError();
  }

  @override
  Future<ParkingCheckIn> checkIn(ParkingCheckIn history) async {
    try {
      history = await firestore.runTransaction((transaction) async {
        bool isMonthlyTicket = false;
        // ref VehicleTicket
        final vehicleRef = firestore
            .collection(vehiclesTicket)
            .where('ticketCode', isEqualTo: history.ticketCode)
            .where('registerDate', isLessThanOrEqualTo: DateTime.now())
            .orderBy('registerDate', descending: true);

        final vehicleQuerySnapshot = await vehicleRef.get();
        if (vehicleQuerySnapshot.docs.isNotEmpty) {
          final vehicleDoc = vehicleQuerySnapshot.docs.first;

          if (vehicleDoc.exists) {
            VehicleTicket vehicleTicket =
                VehicleTicket.fromDocumentSnapshot(vehicleDoc);

            isMonthlyTicket = true;
            if (vehicleTicket.isInParking != null &&
                vehicleTicket.isInParking == true) {
              throw Exception('Thẻ xe đang được sử dụng gửi xe');
            }

            transaction.update(vehicleDoc.reference, {
              'isInParking': true,
            });
          }
        }

        final querySnapshot = await firestore
            .collection(parkingHistory)
            .where('timeOut', isNull: true)
            .where('ticketCode', isEqualTo: true)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          throw Exception('Thẻ xe đã được sử dụng gửi xe');
        }

        final doc = firestore.collection(parkingHistory).doc();
        transaction.set(doc, {
          'vehicleLicensePlate': history.vehicleLicensePlate,
          'ticketCode': history.ticketCode,
          'timeIn': FieldValue.serverTimestamp(),
          'imgIn': history.imgIn,
          'timeOut': history.timeOut,
          'isMonthlyTicket': isMonthlyTicket,
        });

        return history.copyWith(id: doc.id, timeIn: DateTime.now());
      }).catchError((e) {
        logger.e(e);
        throw e;
      });

      return history;
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<ParkingCheckIn> checkOut(ParkingCheckIn parkingCheckIn) async {
    try {
      parkingCheckIn = await firestore.runTransaction((transaction) async {
        final doc = firestore.collection(parkingHistory).doc(parkingCheckIn.id);
        transaction.update(doc, {
          'timeOut': FieldValue.serverTimestamp(),
          'imgOut': parkingCheckIn.imgOut,
          'price': parkingCheckIn.price,
        });
        // ref VehicleTicket
        final vehicleRef = firestore
            .collection('vehicle')
            .where('ticketCode', isEqualTo: parkingCheckIn.ticketCode)
            .limit(1);
        final vehicleQuerySnapshot = await vehicleRef.get();
        if (vehicleQuerySnapshot.docs.isNotEmpty) {
          final vehicleDoc = vehicleQuerySnapshot.docs.first;
          transaction.update(vehicleDoc.reference, {
            'isInParking': false,
          });
        }
        return parkingCheckIn.copyWith(
          timeOut: DateTime.now(),
          imgOut: parkingCheckIn.imgOut,
        );
      });

      return parkingCheckIn;
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<List<ParkingCheckIn>> getParkingCheckInInDate(DateTime date) async {
    try {
      final beginDate = DateTime(date.year, date.month, date.day);
      final endDate = DateTime(date.year, date.month, date.day + 1);
      final querySnapshot = await firestore
          .collection(parkingHistory)
          .where('timeIn', isGreaterThanOrEqualTo: beginDate)
          .where('timeIn', isLessThan: endDate)
          .get();
      return querySnapshot.docs
          .map((e) => ParkingCheckIn.fromDocument(e))
          .toList();
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<List<ParkingCheckIn>> getParkingVehicleBySearch(String q) async {
    try {
      final querySnapshot = await firestore
          .collection(parkingHistory)
          .where('timeOut', isNull: true)
          .where(Filter.or(
            Filter.and(
              Filter('vehicleLicensePlate', isGreaterThanOrEqualTo: q),
              Filter('vehicleLicensePlate', isLessThan: '$q~'),
            ),
            Filter.and(
              Filter('ticketCode', isGreaterThanOrEqualTo: q),
              Filter('ticketCode', isLessThan: '$q~'),
            ),
          ))
          .get();
      return querySnapshot.docs
          .map((e) => ParkingCheckIn.fromDocument(e))
          .toList();
    } catch (e) {
      logger.e(e);
      throw e;
    }
  }

  @override
  Future<List<ParkingCheckIn>> getParkingCheckInByTicketId(String ticketId) {
    throw UnimplementedError();
  }

  @override
  Future<List<ParkingCheckIn>> getParkingInParkingLot() {
    try {
      final querySnapshot = firestore
          .collection(parkingHistory)
          .where('timeOut', isNull: true)
          .get();
      return querySnapshot.then((value) =>
          value.docs.map((e) => ParkingCheckIn.fromDocument(e)).toList());
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<bool> isVehicleInParking(String ticketCode) async {
    try {
      final querySnapshot = await firestore
          .collection(parkingHistory)
          .where('ticketCode', isEqualTo: ticketCode)
          .where('timeOut', isNull: true)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }
}
