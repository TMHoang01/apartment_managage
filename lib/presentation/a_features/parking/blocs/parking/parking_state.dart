part of 'parking_bloc.dart';

enum ParkingStatus { initial, loading, loaded, error }

class ParkingState extends Equatable {
  final List<ParkingLot> list;
  final ParkingLot? lotSelect;
  final String message;
  final ParkingStatus status;

  const ParkingState({
    this.list = const <ParkingLot>[],
    this.lotSelect,
    this.message = '',
    this.status = ParkingStatus.initial,
  });

  ParkingState copyWith({
    List<ParkingLot>? list,
    ParkingLot? lotSelect,
    String? message,
    ParkingStatus? status,
  }) {
    return ParkingState(
      list: list ?? this.list,
      lotSelect: lotSelect ?? this.lotSelect,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [list, message, status, lotSelect];
}
