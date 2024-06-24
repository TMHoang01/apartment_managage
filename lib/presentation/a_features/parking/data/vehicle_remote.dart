import 'package:apartment_managage/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apartment_managage/presentation/a_features/parking/domain/model/vehicle_ticket.dart';

abstract class VehicleRemoteDataSource {
  Future<List<VehicleTicket>> getManageVehicles(String userId);

  Future<VehicleTicket> getVehicle(String id);

  Future<VehicleTicket> comfirmRegisterVehicle(VehicleTicket vehicle);

  Future<VehicleTicket> updateVehicle(VehicleTicket vehicle);

  Future<void> deleteVehicle(String id);

  Future<List<VehicleTicket>> getTicketNeedApprovel();

  Future<VehicleTicket> updateVehicleStatus(String id, String status);
}

class VehicleRemoteDataSourceImpl implements VehicleRemoteDataSource {
  final storage = FirebaseFirestore.instance;
  final String vehicleCollection = 'vehicles';

  @override
  Future<VehicleTicket> comfirmRegisterVehicle(VehicleTicket vehicle) async {
    try {
      final code = vehicle.ticketCode ?? '';

      if (code.isEmpty) {
        throw 'Mã thẻ không hợp lệ';
      }

      // Check if code is exist
      final querySnapshot = await storage
          .collection(vehicleCollection)
          .where('ticketCode', isEqualTo: code)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        throw 'Mã thẻ đã tồn tại';
      }

      final vehicleRef = storage.collection(vehicleCollection).doc(vehicle.id);
      await vehicleRef.update({
        'status': vehicle.status?.toJson(),
        'updatedAt': DateTime.now(),
        'registerDate': DateTime.now(),
        'expireDate': DateTime.now().add(const Duration(days: 30)),
      });

      final vehicleSnapshot = await vehicleRef.get();
      return VehicleTicket.fromDocumentSnapshot(vehicleSnapshot);
    } catch (e) {
      logger.e(e);
      throw e;
    }
  }

  @override
  Future<void> deleteVehicle(String id) {
    // TODO: implement deleteVehicle
    throw UnimplementedError();
  }

  @override
  Future<List<VehicleTicket>> getManageVehicles(String userId) async {
    try {
      final querySnapshot = await storage
          .collection(vehicleCollection)
          .where('status', isEqualTo: 'active')
          .get();
      return querySnapshot.docs
          .map((e) => VehicleTicket.fromDocumentSnapshot(e))
          .toList();
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<VehicleTicket> getVehicle(String id) {
    // TODO: implement getVehicle
    throw UnimplementedError();
  }

  @override
  Future<VehicleTicket> updateVehicle(VehicleTicket vehicle) {
    // TODO: implement updateVehicle
    throw UnimplementedError();
  }

  @override
  Future<List<VehicleTicket>> getTicketNeedApprovel() async {
    final querySnapshot = await storage
        .collection(vehicleCollection)
        .where('status', isEqualTo: 'pending')
        .get();
    return querySnapshot.docs
        .map((e) => VehicleTicket.fromDocumentSnapshot(e))
        .toList();
  }

  @override
  Future<VehicleTicket> updateVehicleStatus(String id, String status) async {
    try {
      final vehicleRef = storage.collection(vehicleCollection).doc(id);
      if (status == 'active') {
        await vehicleRef.update({
          'status': status,
          'updatedAt': DateTime.now(),
          'registerDate': DateTime.now(),
          'expireDate': DateTime.now().add(const Duration(days: 30)),
        });
      } else {
        await vehicleRef.update({
          'status': status,
          'updatedAt': DateTime.now(),
        });
      }
      final vehicleSnapshot = await vehicleRef.get();
      return VehicleTicket.fromDocumentSnapshot(vehicleSnapshot);
    } catch (e) {
      logger.e(e);
      throw e;
    }
  }
}
