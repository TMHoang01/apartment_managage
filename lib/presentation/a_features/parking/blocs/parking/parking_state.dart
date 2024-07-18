part of 'parking_bloc.dart';

enum ParkingStatus { initial, loading, modify, loaded, error }

class ParkingState extends Equatable {
  final List<ParkingLot> list;
  final ParkingLot? lotSelect;
  final List<VehicleTicket> listVehicleInParking;
  final VehicleTicket? vehicleSelect;
  final String message;
  final ParkingStatus status;

  const ParkingState({
    this.list = const <ParkingLot>[],
    this.lotSelect,
    this.listVehicleInParking = const <VehicleTicket>[],
    this.vehicleSelect,
    this.message = '',
    this.status = ParkingStatus.initial,
  });

  ParkingState copyWith({
    List<ParkingLot>? list,
    ParkingLot? lotSelect,
    List<VehicleTicket>? listVehicleInParking,
    VehicleTicket? vehicleSelect,
    String? message,
    ParkingStatus? status,
  }) {
    return ParkingState(
      list: list ?? this.list,
      lotSelect: lotSelect ?? this.lotSelect,
      listVehicleInParking: listVehicleInParking ?? this.listVehicleInParking,
      vehicleSelect: vehicleSelect ?? this.vehicleSelect,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        list,
        lotSelect,
        vehicleSelect,
        listVehicleInParking,
        vehicleSelect,
        message,
        status,
      ];
}
