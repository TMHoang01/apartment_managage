import 'package:apartment_managage/presentation/a_features/parking/data/parking_remote.dart';
import 'package:apartment_managage/presentation/a_features/parking/domain/model/parking_checkin.dart';

abstract class ParkingCheckinRepository {
  Future<ParkingCheckIn> checkIn(ParkingCheckIn history);
  Future<ParkingCheckIn> checkOut(ParkingCheckIn history);
  Future<List<ParkingCheckIn>> getParkingCheckInInDate(DateTime date);
  Future<List<ParkingCheckIn>> getParkingInParking();
  Future<List<ParkingCheckIn>> getParkingVehicleBySearch(String q);
  Future<bool> isVehicleInParking(String ticketCode);
}

class ParkingCheckinRepositoryImpl implements ParkingCheckinRepository {
  ParkingRemoteDataSource parkingCheckInRemoteDataSource;

  ParkingCheckinRepositoryImpl(this.parkingCheckInRemoteDataSource);

  @override
  Future<ParkingCheckIn> checkIn(ParkingCheckIn history) async {
    return await parkingCheckInRemoteDataSource.checkIn(history);
  }

  @override
  Future<ParkingCheckIn> checkOut(ParkingCheckIn history) async {
    return await parkingCheckInRemoteDataSource.checkOut(history);
  }

  @override
  Future<List<ParkingCheckIn>> getParkingCheckInInDate(DateTime date) async {
    return await parkingCheckInRemoteDataSource.getParkingCheckInInDate(date);
  }

  @override
  Future<List<ParkingCheckIn>> getParkingInParking() async {
    return await parkingCheckInRemoteDataSource.getParkingInParkingLot();
  }

  @override
  Future<bool> isVehicleInParking(String ticketCode) async {
    return await parkingCheckInRemoteDataSource.isVehicleInParking(ticketCode);
  }

  @override
  Future<List<ParkingCheckIn>> getParkingVehicleBySearch(String q) async {
    return await parkingCheckInRemoteDataSource.getParkingVehicleBySearch(q);
  }
}
