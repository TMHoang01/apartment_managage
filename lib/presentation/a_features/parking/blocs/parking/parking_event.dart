part of 'parking_bloc.dart';

sealed class ParkingEvent extends Equatable {
  const ParkingEvent();

  @override
  List<Object> get props => [];
}

class ParkingStarted extends ParkingEvent {}

class ParkingUpdateSlot extends ParkingEvent {
  final List<ParkingLot> list;
  const ParkingUpdateSlot({required this.list});

  @override
  List<Object> get props => [list];
}

class ParkingSelectLot extends ParkingEvent {
  final ParkingLot lot;
  const ParkingSelectLot(this.lot);
}
