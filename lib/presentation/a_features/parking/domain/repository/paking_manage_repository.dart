import 'package:apartment_managage/presentation/a_features/parking/data/parking_remote.dart';
import 'package:apartment_managage/presentation/a_features/parking/domain/model/parking_history.dart';

abstract class ParkingCheckInRepository {
  Future<ParkingHistory> checkIn(ParkingHistory history);
  Future<ParkingHistory> checkOut(ParkingHistory history);
  Future<List<ParkingHistory>> getParkingHistoryInDate(DateTime date);
}

class ParkingHistoRyRepositoryImpl implements ParkingCheckInRepository {
  ParkingRemoteDataSource parkingCheckInRemoteDataSource;

  ParkingHistoRyRepositoryImpl(this.parkingCheckInRemoteDataSource);

  @override
  Future<ParkingHistory> checkIn(ParkingHistory history) async {
    return await parkingCheckInRemoteDataSource.checkIn(history);
  }

  @override
  Future<ParkingHistory> checkOut(ParkingHistory history) async {
    return await parkingCheckInRemoteDataSource.checkOut(history);
  }

  @override
  Future<List<ParkingHistory>> getParkingHistoryInDate(DateTime date) async {
    return await parkingCheckInRemoteDataSource.getParkingHistoryInDate(date);
  }
}
