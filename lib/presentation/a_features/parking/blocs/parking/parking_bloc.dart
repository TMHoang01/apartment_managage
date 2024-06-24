import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:apartment_managage/presentation/a_features/parking/domain/model/parking_lot.dart';
import 'package:apartment_managage/presentation/a_features/parking/domain/repository/paking_lot_repository.dart';

part 'parking_event.dart';
part 'parking_state.dart';

class ParkingBloc extends Bloc<ParkingEvent, ParkingState> {
  final ParkingLotRepository parkingLotRepository;
  ParkingBloc(this.parkingLotRepository) : super(ParkingState()) {
    on<ParkingEvent>((event, emit) {});
    on<ParkingStarted>(_onParkingStarted, transformer: droppable());
    on<ParkingSelectLot>(_onParkingSelectLot, transformer: droppable());
  }

  void _onParkingStarted(
    ParkingStarted event,
    Emitter<ParkingState> emit,
  ) async {
    emit(state.copyWith(status: ParkingStatus.loading));
    try {
      final list = await parkingLotRepository.getParkingLotsInFloor('1');
      emit(state.copyWith(status: ParkingStatus.loaded, list: list));
    } catch (e) {
      emit(state.copyWith(status: ParkingStatus.error));
    }
  }

  Future<void> _onParkingSelectLot(
    ParkingSelectLot event,
    Emitter<ParkingState> emit,
  ) async {
    emit(state.copyWith(lotSelect: event.lot));
  }
}
