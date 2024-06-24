part of 'vehicle_list_bloc.dart';

enum ManageVehicleStatus { initial, loading, loaded, error }

class ManageVehicleState extends Equatable {
  final ManageVehicleStatus status;
  final List<VehicleTicket> list;
  final VehicleTicket? ticketSelect;
  final String message;
  final ManageVehicleStatus createStatus;

  const ManageVehicleState({
    this.status = ManageVehicleStatus.initial,
    this.list = const <VehicleTicket>[],
    this.ticketSelect,
    this.message = '',
    this.createStatus = ManageVehicleStatus.initial,
  });

  ManageVehicleState copyWith({
    ManageVehicleStatus? status,
    List<VehicleTicket>? list,
    VehicleTicket? ticketSelect,
    String? message,
    ManageVehicleStatus? createStatus,
  }) {
    return ManageVehicleState(
      status: status ?? this.status,
      list: list ?? this.list,
      ticketSelect: ticketSelect ?? this.ticketSelect,
      message: message ?? this.message,
      createStatus: createStatus ?? this.createStatus,
    );
  }

  ManageVehicleState emptySelected() {
    return ManageVehicleState(
      status: status,
      list: list,
      ticketSelect: null,
      message: message,
      createStatus: createStatus,
    );
  }

  @override
  List<Object?> get props =>
      [status, list, ticketSelect, message, createStatus];
}
