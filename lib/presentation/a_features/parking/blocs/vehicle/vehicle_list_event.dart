part of 'vehicle_list_bloc.dart';

sealed class ManageVehicleEvent extends Equatable {
  const ManageVehicleEvent();

  @override
  List<Object> get props => [];
}

class ManageVehicleRegisterlStarted extends ManageVehicleEvent {}

class ManageVehicleTicketStarted extends ManageVehicleEvent {}

class ManageVehicleCreate extends ManageVehicleEvent {
  final VehicleTicket vehicle;
  const ManageVehicleCreate({required this.vehicle});

  @override
  List<Object> get props => [vehicle];
}

class ManageVehicleConfirmRegister extends ManageVehicleEvent {
  final String ticketId;
  const ManageVehicleConfirmRegister(
    this.ticketId,
  );

  @override
  List<Object> get props => [ticketId];
}

class ManageVehicleUpdateStatus extends ManageVehicleEvent {
  final String ticketId;
  final TicketStatus status;
  const ManageVehicleUpdateStatus(
    this.ticketId,
    this.status,
  );

  @override
  List<Object> get props => [ticketId, status];
}
