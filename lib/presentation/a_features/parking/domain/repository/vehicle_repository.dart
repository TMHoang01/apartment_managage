import 'package:apartment_managage/presentation/a_features/parking/data/vehicle_remote.dart';
import 'package:apartment_managage/presentation/a_features/parking/domain/model/vehicle_ticket.dart';

abstract class VehicleRepository {
  Future<List<VehicleTicket>> getTicketActive(String userId);
  Future<List<VehicleTicket>> getTicketNeedApprovel();
  Future<VehicleTicket> getVehicle(String id);
  Future<VehicleTicket> comfirmRegisterVehicle(VehicleTicket vehicle);
  Future<VehicleTicket> updateVehicleStatus(String id, String status);
  Future<void> deleteVehicle(String id);
}

class VehicleRepositoryImpl implements VehicleRepository {
  VehicleRemoteDataSource vehicleRemoteDataSource;

  VehicleRepositoryImpl(this.vehicleRemoteDataSource);

  @override
  Future<List<VehicleTicket>> getTicketActive(String userId) async {
    return vehicleRemoteDataSource.getManageVehicles(userId);
  }

  @override
  Future<List<VehicleTicket>> getTicketNeedApprovel() async {
    return vehicleRemoteDataSource.getTicketNeedApprovel();
  }

  @override
  Future<VehicleTicket> getVehicle(String id) async {
    return vehicleRemoteDataSource.getVehicle(id);
  }

  @override
  Future<VehicleTicket> comfirmRegisterVehicle(VehicleTicket vehicle) async {
    return vehicleRemoteDataSource.comfirmRegisterVehicle(vehicle);
  }

  @override
  Future<VehicleTicket> updateVehicleStatus(String id, String status) async {
    return vehicleRemoteDataSource.updateVehicleStatus(id, status);
  }

  @override
  Future<void> deleteVehicle(String id) {
    return vehicleRemoteDataSource.deleteVehicle(id);
  }
}
