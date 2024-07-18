import 'package:apartment_managage/presentation/a_features/parking/data/parking_remote.dart';
import 'package:apartment_managage/presentation/a_features/parking/domain/model/parking_checkin.dart';

abstract class ParkingHistoryRepository {
  Future<ParkingHistory> checkIn(ParkingHistory history);
  Future<ParkingHistory> checkOut(ParkingHistory history);
  Future<List<ParkingHistory>> getParkingCheckInInDate(DateTime date);
  Future<List<ParkingHistory>> getParkingInParking();
  Future<List<ParkingHistory>> getParkingVehicleBySearch(String q);
  Future<bool> isVehicleInParking(String ticketCode);
}

class ParkingCheckinRepositoryImpl implements ParkingHistoryRepository {
  ParkingRemoteDataSource parkingCheckInRemoteDataSource;

  ParkingCheckinRepositoryImpl(this.parkingCheckInRemoteDataSource);

  @override
  Future<ParkingHistory> checkIn(ParkingHistory history) async {
    return await parkingCheckInRemoteDataSource.checkIn(history);
  }

  @override
  Future<ParkingHistory> checkOut(ParkingHistory history) async {
    return await parkingCheckInRemoteDataSource.checkOut(history);
  }

  @override
  Future<List<ParkingHistory>> getParkingCheckInInDate(DateTime date) async {
    return await parkingCheckInRemoteDataSource.getParkingCheckInInDate(date);
  }

  @override
  Future<List<ParkingHistory>> getParkingInParking() async {
    return await parkingCheckInRemoteDataSource.getParkingInParkingLot();
  }

  @override
  Future<bool> isVehicleInParking(String ticketCode) async {
    return await parkingCheckInRemoteDataSource.isVehicleInParking(ticketCode);
  }

  @override
  Future<List<ParkingHistory>> getParkingVehicleBySearch(String q) async {
    return await parkingCheckInRemoteDataSource.getParkingVehicleBySearch(q);
  }
}
