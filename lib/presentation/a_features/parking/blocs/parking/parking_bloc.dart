import 'package:apartment_managage/presentation/a_features/parking/domain/model/parking_checkin.dart';
import 'package:apartment_managage/presentation/a_features/parking/domain/model/vehicle_ticket.dart';
import 'package:apartment_managage/presentation/a_features/parking/domain/repository/paking_checkin_repository.dart';
import 'package:apartment_managage/presentation/a_features/parking/domain/repository/vehicle_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:apartment_managage/presentation/a_features/parking/domain/model/parking_lot.dart';
import 'package:apartment_managage/presentation/a_features/parking/domain/repository/paking_lot_repository.dart';
import 'package:flutter/material.dart';

part 'parking_event.dart';
part 'parking_state.dart';

class ParkingBloc extends Bloc<ParkingEvent, ParkingState> {
  final ParkingLotRepository parkingLotRepository;
  final VehicleRepository vehicleRepository;
  ParkingBloc(this.parkingLotRepository, this.vehicleRepository)
      : super(ParkingState()) {
    on<ParkingEvent>((event, emit) {});
    on<ParkingStarted>(_onParkingStarted, transformer: droppable());
    on<ParkingSelectLot>(_onParkingSelectLot, transformer: droppable());
    on<ParkingSelectVehicle>(_onParkingSelectVehicle, transformer: droppable());

    on<ParkingInProccess>(_onParkingInProccess, transformer: droppable());
  }

  void _onParkingStarted(
    ParkingStarted event,
    Emitter<ParkingState> emit,
  ) async {
    emit(state.copyWith(status: ParkingStatus.loading));
    try {
      final list = await parkingLotRepository.getParkingLotsInFloor('1');
      final listVehicle = await vehicleRepository.getVehicleInParking();
      emit(state.copyWith(
        status: ParkingStatus.loaded,
        list: list,
        listVehicleInParking: listVehicle,
      ));
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

  Future<void> _onParkingSelectVehicle(
    ParkingSelectVehicle event,
    Emitter<ParkingState> emit,
  ) async {
    emit(state.copyWith(vehicleSelect: event.vehicle));
  }

  Future<void> _onParkingInProccess(
    ParkingInProccess event,
    Emitter<ParkingState> emit,
  ) async {
    // emit(state.copyWith(status: ParkingStatus.modify));
    // try {
    //   final ticket = state.vehicleSelect;
    //   await parkingLotRepository.inParking(state.lot, state.ticket);
    //   emit(
    //     state
    //         .copyWith(
    //           status: ParkingStatus.loaded,
    //           list: state.list.map((e) {
    //             if (e.id == state.lot.id) {
    //               return e.copyWith(
    //                 status: ParkingLotStatus.occupiedKnown,
    //                 vehicleLicensePlate: ticket.vehicleLicensePlate,
    //                 ticketId: ticket.id,
    //               );
    //             }
    //             return e;
    //           }).toList(),
    //         )
    //         .emptyLotSelect(),
    //   );
    // } catch (e) {
    //   emit(state.copyWith(message: e.toString()));
    // }
  }
}
