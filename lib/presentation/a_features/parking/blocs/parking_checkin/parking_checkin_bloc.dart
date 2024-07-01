import 'package:apartment_managage/presentation/a_features/parking/domain/model/parking_checkin.dart';
import 'package:apartment_managage/presentation/a_features/parking/domain/model/vehicle_ticket.dart';
import 'package:apartment_managage/presentation/a_features/parking/domain/repository/paking_checkin_repository.dart';
import 'package:apartment_managage/presentation/a_features/parking/domain/repository/vehicle_repository.dart';
import 'package:apartment_managage/utils/logger.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'parking_checkin_event.dart';
part 'parking_checkin_state.dart';

class ParkingCheckInBloc
    extends Bloc<ParkingCheckInEvent, ParkingCheckInState> {
  final ParkingCheckinRepository parkingHistoryRepository;
  final VehicleRepository vehicleRepository;
  ParkingCheckInBloc(this.parkingHistoryRepository, this.vehicleRepository)
      : super(const ParkingCheckInState()) {
    on<ParkingCheckInEvent>((event, emit) {});
    on<ParkingCheckInStarted>(_onParkingCheckInStarted);
    on<ParkingCheckInCheckInStarted>(_onParkingCheckInCheckInStarted);
    on<ParkingCheckInCheckOutStarted>(_onParkingCheckInCheckOutStarted);
    on<ParkingCheckInSearchInParking>(_onParkingCheckInSearchInParking);
  }

  Future<void> _onParkingCheckInStarted(
      ParkingCheckInStarted event, Emitter<ParkingCheckInState> emit) async {
    emit(state.copyWith(status: ParkingCheckInStatus.loading));
    try {
      final list = await parkingHistoryRepository.getParkingInParking();
      emit(state.copyWith(list: list, status: ParkingCheckInStatus.loaded));
    } catch (e) {
      emit(state.copyWith(
          message: e.toString(), status: ParkingCheckInStatus.error));
    }
  }

  Future<void> _onParkingCheckInCheckInStarted(
      ParkingCheckInCheckInStarted event,
      Emitter<ParkingCheckInState> emit) async {
    ParkingCheckIn history = event.parkingHistory;
    emit(state.copyWith(
        select: history, statusIn: ParkingCheckInStatus.loading));
    try {
      String? ticketCode = event.parkingHistory.ticketCode;
      if (ticketCode != null) {
        final VehicleTicket? ticket =
            await vehicleRepository.getVehicleByCode(ticketCode);
        logger.d('ticket: $ticket');
        if (ticket != null && ticket.isInParking == true) {
          emit(state.copyWith(
              ticket: ticket,
              message: 'Thẻ xe đã được sử dụng gửi xe',
              statusIn: ParkingCheckInStatus.error));
          return;
        }
        if (ticket?.vehicleLicensePlate == null &&
            history.isLicensePlateEmpty) {
          emit(state.copyWith(
              message: 'Vui lòng nhập đúng mã thẻ xe, biển số xe',
              statusIn: ParkingCheckInStatus.error));
          return;
        }
        bool isInParking =
            await parkingHistoryRepository.isVehicleInParking(ticketCode);
        if (isInParking) {
          emit(
            state.copyWith(
                message: 'Thẻ xe đã gửi xe, vui lòng kiểm tra lại',
                statusIn: ParkingCheckInStatus.error),
          );
          return;
        }

        if (history.isLicensePlateEmpty) {
          history = history.copyWith(
              vehicleLicensePlate: ticket?.vehicleLicensePlate ?? '');
        }
        final result = await parkingHistoryRepository.checkIn(history);
        // add in index 0
        final list = state.list;
        list.insert(0, result);
        emit(state.copyWith(statusIn: ParkingCheckInStatus.loaded, list: list));
      }
    } catch (e) {
      emit(state.copyWith(
          message: e.toString(), statusIn: ParkingCheckInStatus.error));
    }
  }

  Future<void> _onParkingCheckInCheckOutStarted(
      ParkingCheckInCheckOutStarted event,
      Emitter<ParkingCheckInState> emit) async {
    ParkingCheckIn history = event.parkingHistory.copyWith(
      timeOut: DateTime.now(),
    )..setPrice();
    emit(state.copyWith(
        select: history, statusOut: ParkingCheckInStatus.loading));
    // try {
    //   final result = await parkingHistoryRepository.checkOut(history);
    //   emit(
    //     state.copyWith(
    //         statusOut: ParkingCheckInStatus.loaded,
    //         list: state.list.map((e) {
    //           if (e.id == result.id) {
    //             return result;
    //           }
    //           return e;
    //         }).toList()),
    //   );
    // } catch (e) {
    //   emit(state.copyWith(
    //       message: e.toString(), statusOut: ParkingCheckInStatus.error));
    // }
  }

  Future<void> _onParkingCheckInSearchInParking(
      ParkingCheckInSearchInParking event,
      Emitter<ParkingCheckInState> emit) async {
    emit(state.copyWith(status: ParkingCheckInStatus.loading));
    try {
      if (event.q == null || event.q!.isEmpty) {
        final list = await parkingHistoryRepository.getParkingInParking();
        emit(state.copyWith(list: list, status: ParkingCheckInStatus.loaded));
        return;
      }
      final list =
          await parkingHistoryRepository.getParkingVehicleBySearch(event.q!);
      emit(state.copyWith(list: list, status: ParkingCheckInStatus.loaded));
    } catch (e) {
      emit(state.copyWith(
          message: e.toString(), status: ParkingCheckInStatus.error));
    }
  }
}
