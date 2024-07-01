part of 'parking_checkin_bloc.dart';

enum ParkingCheckInStatus { initial, loading, loaded, error }

class ParkingCheckInState extends Equatable {
  final List<ParkingCheckIn> list;
  final ParkingCheckIn? select;
  final VehicleTicket? ticket;
  final String message;
  final ParkingCheckInStatus status;
  final ParkingCheckInStatus? statusIn;
  final ParkingCheckInStatus? statusOut;

  const ParkingCheckInState({
    this.list = const <ParkingCheckIn>[],
    this.select,
    this.ticket,
    this.message = '',
    this.status = ParkingCheckInStatus.initial,
    this.statusIn,
    this.statusOut,
  });

  ParkingCheckInState copyWith({
    List<ParkingCheckIn>? list,
    ParkingCheckIn? select,
    VehicleTicket? ticket,
    String? message,
    ParkingCheckInStatus? status,
    ParkingCheckInStatus? statusIn,
    ParkingCheckInStatus? statusOut,
  }) {
    return ParkingCheckInState(
      list: list ?? this.list,
      select: select ?? this.select,
      ticket: ticket,
      message: message ?? '',
      status: status ?? this.status,
      statusIn: statusIn ?? this.statusIn,
      statusOut: statusOut ?? this.statusOut,
    );
  }

  ParkingCheckInState emptySelect() {
    return ParkingCheckInState(
      list: list,
      select: null,
      ticket: null,
      message: '',
      status: status,
      statusIn: null,
      statusOut: null,
    );
  }

  @override
  List<Object?> get props =>
      [list, select, ticket, message, status, statusIn, statusOut];
}
