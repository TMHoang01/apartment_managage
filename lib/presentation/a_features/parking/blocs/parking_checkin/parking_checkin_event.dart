part of 'parking_checkin_bloc.dart';

sealed class ParkingCheckInEvent extends Equatable {
  const ParkingCheckInEvent();

  @override
  List<Object> get props => [];
}

class ParkingCheckInStarted extends ParkingCheckInEvent {}

class ParkingCheckInCheckInStarted extends ParkingCheckInEvent {
  final ParkingCheckIn parkingHistory;

  const ParkingCheckInCheckInStarted(this.parkingHistory);
}

class ParkingCheckInCheckOutStarted extends ParkingCheckInEvent {
  final ParkingCheckIn parkingHistory;

  const ParkingCheckInCheckOutStarted(this.parkingHistory);
}

class ParkingCheckInSearchInParking extends ParkingCheckInEvent {
  final String? q;
  const ParkingCheckInSearchInParking(this.q);
}
