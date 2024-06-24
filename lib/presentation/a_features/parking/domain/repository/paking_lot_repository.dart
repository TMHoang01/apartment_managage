import 'package:apartment_managage/presentation/a_features/parking/data/parking_remote.dart';
import 'package:apartment_managage/presentation/a_features/parking/domain/model/parking_lot.dart';

abstract class ParkingLotRepository {
  Future<List<ParkingLot>> getParkingLotsInFloor(String floor);
  Future<ParkingLot> updateParkingLot(ParkingLot parkingLot);
}

class ParkingLotRepositoryImpl implements ParkingLotRepository {
  ParkingRemoteDataSource parkingRemoteDataSource;

  ParkingLotRepositoryImpl(this.parkingRemoteDataSource);

  @override
  Future<List<ParkingLot>> getParkingLotsInFloor(String floor) {
    return parkingRemoteDataSource.getParkingLotsInFloor(floor);
  }

  @override
  Future<ParkingLot> updateParkingLot(ParkingLot parkingLot) {
    return parkingRemoteDataSource.updateParkingLot(parkingLot);
  }
}
