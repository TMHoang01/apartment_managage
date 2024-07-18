import 'package:apartment_managage/presentation/a_features/parking/domain/model/parking_checkin.dart';
import 'package:apartment_managage/presentation/a_features/parking/domain/model/vehicle_ticket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apartment_managage/presentation/a_features/parking/domain/model/parking_lot.dart';
import 'package:apartment_managage/utils/utils.dart';

abstract class ParkingRemoteDataSource {
  Future<List<ParkingLot>> getParkingLotsInFloor(String floor);

  Future<ParkingLot> updateParkingLot(ParkingLot parkingLot);

  Future<ParkingHistory> checkIn(ParkingHistory history);
  Future<ParkingHistory> checkOut(ParkingHistory parkingLot);
  Future<List<ParkingHistory>> getParkingCheckInInDate(DateTime date);
  Future<List<ParkingHistory>> getParkingVehicleBySearch(String q);
  Future<List<ParkingHistory>> getParkingCheckInByTicketId(String ticketId);
  Future<List<ParkingHistory>> getParkingInParkingLot();

  Future<bool> isVehicleInParking(String ticketCode);

  Future<void> inParking(ParkingLot lot, VehicleTicket ticket);
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
  Future<ParkingHistory> checkIn(ParkingHistory history) async {
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

            isMonthlyTicket = vehicleTicket.isExpired ? false : true;
            if (vehicleTicket.isInParking != null &&
                vehicleTicket.isInParking == true) {
              throw Exception('Thẻ xe đang được sử dụng gửi xe');
            }

            transaction.update(vehicleDoc.reference, {
              'isInParking': true,
            });
          }
        } else {
          final newVehicleTicket = VehicleTicket(
            ticketCode: history.ticketCode,
            registerDate: DateTime.now(),
            isInParking: true,
            vehicleLicensePlate: history.vehicleLicensePlate,
          );

          final newVehicleDocRef = firestore.collection(vehiclesTicket).doc();
          transaction.set(newVehicleDocRef, newVehicleTicket.toJson());
          isMonthlyTicket = false;
        }

        final querySnapshot = await firestore
            .collection(parkingHistory)
            .where('timeOut', isNull: true)
            .where('ticketCode', isEqualTo: history.ticketCode)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          throw Exception('Thẻ xe đã được sử dụng gửi xe');
        }

        final doc = firestore.collection(parkingHistory).doc();
        final newDoc = history.copyWith(
          isMonthlyTicket: isMonthlyTicket,
          timeIn: DateTime.now(),
        );
        transaction.set(doc, newDoc.toJson());

        return newDoc.copyWith(id: doc.id);
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
  Future<ParkingHistory> checkOut(ParkingHistory parkingCheckIn) async {
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
            .collection(vehiclesTicket)
            .where('ticketCode', isEqualTo: parkingCheckIn.ticketCode)
            .limit(1);
        final vehicleQuerySnapshot = await vehicleRef.get();
        if (vehicleQuerySnapshot.docs.isNotEmpty) {
          final vehicleDoc = vehicleQuerySnapshot.docs.first;
          final VehicleTicket vehicleTicket =
              VehicleTicket.fromDocumentSnapshot(vehicleDoc);
          final parkingLotId = vehicleTicket.parkingLotId;
          final vehicleLicensePlate = vehicleTicket.userId != null
              ? vehicleTicket.vehicleLicensePlate
              : null;
          transaction.update(vehicleDoc.reference, {
            'isInParking': false,
            'parkingFloor': null,
            'parkingLotId': null,
            'parkingLotName': null,
            'vehicleLicensePlate': vehicleLicensePlate,
          });
          if (parkingLotId != null) {
            final parkingDocRef =
                firestore.collection(parking).doc(parkingLotId);

            transaction.update(parkingDocRef, {
              'vehicleLicensePlate': null,
              'ticketId': null,
              'ticketCode': null,
            });
          }
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
  Future<List<ParkingHistory>> getParkingCheckInInDate(DateTime date) async {
    try {
      final beginDate = DateTime(date.year, date.month, date.day);
      final endDate = DateTime(date.year, date.month, date.day + 1);
      final querySnapshot = await firestore
          .collection(parkingHistory)
          .where('timeIn', isGreaterThanOrEqualTo: beginDate)
          .where('timeIn', isLessThan: endDate)
          .get();
      return querySnapshot.docs
          .map((e) => ParkingHistory.fromDocument(e))
          .toList();
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<List<ParkingHistory>> getParkingVehicleBySearch(String q) async {
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
          .map((e) => ParkingHistory.fromDocument(e))
          .toList();
    } catch (e) {
      logger.e(e);
      throw e;
    }
  }

  @override
  Future<List<ParkingHistory>> getParkingCheckInByTicketId(String ticketId) {
    throw UnimplementedError();
  }

  @override
  Future<List<ParkingHistory>> getParkingInParkingLot() {
    try {
      final querySnapshot = firestore
          .collection(parkingHistory)
          .where('timeOut', isNull: true)
          .get();
      return querySnapshot.then((value) =>
          value.docs.map((e) => ParkingHistory.fromDocument(e)).toList());
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

  @override
  Future<void> inParking(ParkingLot lot, VehicleTicket ticket) async {
    // update transaction parking lot: status, vehicleLicensePlate, and ticketId
    // and vehicle: status, parkingFloor, parkingLotId
    try {
      final response = await firestore.runTransaction((transaction) async {
        final lotRef = firestore.collection(parking).doc(lot.id);
        final lotDoc = await transaction.get(lotRef);
        if (!lotDoc.exists) {
          throw Exception('Vị trí đỗ xe không tồn tại');
        }

        final ticketRef = firestore.collection(vehiclesTicket).doc(ticket.id);
        final ticketDoc = await transaction.get(ticketRef);
        if (!ticketDoc.exists) {
          throw Exception('Không tìm thế thẻ xe');
        }

        transaction.update(lotRef, {
          'status': ParkingLotStatus.occupiedKnown.toJson(),
          'vehicleLicensePlate': ticket.vehicleLicensePlate,
          'ticketId': ticket.id,
          'timeIn': FieldValue.serverTimestamp(),
        });

        transaction.update(ticketRef, {
          'parkingFloor': lot.floor,
          'parkingLotId': lot.id,
          'parkingLotName': lot.name,
        });

        return lot;
      });
    } catch (e) {
      logger.e(e);
      throw e;
    }
  }
}
