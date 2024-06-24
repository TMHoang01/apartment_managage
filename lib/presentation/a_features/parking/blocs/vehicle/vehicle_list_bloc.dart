import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:apartment_managage/presentation/a_features/parking/domain/model/vehicle_ticket.dart';
import 'package:apartment_managage/presentation/a_features/parking/domain/repository/vehicle_repository.dart';
import 'package:apartment_managage/utils/utils.dart';

part 'vehicle_list_event.dart';
part 'vehicle_list_state.dart';

class ManageVehicleTicketBloc
    extends Bloc<ManageVehicleEvent, ManageVehicleState> {
  final VehicleRepository vehicleRepository;
  ManageVehicleTicketBloc(this.vehicleRepository)
      : super(const ManageVehicleState()) {
    on<ManageVehicleEvent>((event, emit) {});

    on<ManageVehicleRegisterlStarted>(_onManageVehicleStarted,
        transformer: droppable());
    on<ManageVehicleCreate>(_onManageVehicleCreate, transformer: droppable());
    on<ManageVehicleConfirmRegister>(_onManageVehicleConfirmRegister,
        transformer: droppable());

    on<ManageVehicleUpdateStatus>(_onManageVehicleUpdateStatus,
        transformer: droppable());

    on<ManageVehicleTicketStarted>(_onManageVehicleTicketStarted,
        transformer: droppable());
  }

  void _onManageVehicleStarted(
    ManageVehicleRegisterlStarted event,
    Emitter<ManageVehicleState> emit,
  ) async {
    emit(state.copyWith(status: ManageVehicleStatus.loading));
    try {
      final list = await vehicleRepository.getTicketNeedApprovel();
      emit(state.copyWith(status: ManageVehicleStatus.loaded, list: list));
    } catch (e) {
      emit(state.copyWith(status: ManageVehicleStatus.error));
    }
  }

  void _onManageVehicleTicketStarted(
    ManageVehicleTicketStarted event,
    Emitter<ManageVehicleState> emit,
  ) async {
    emit(state.copyWith(status: ManageVehicleStatus.loading));
    try {
      final userId = userCurrent?.uid ?? '';
      final list = await vehicleRepository.getTicketActive(userId);
      emit(state.copyWith(status: ManageVehicleStatus.loaded, list: list));
    } catch (e) {
      emit(state.copyWith(status: ManageVehicleStatus.error));
    }
  }

  void _onManageVehicleCreate(
    ManageVehicleCreate event,
    Emitter<ManageVehicleState> emit,
  ) async {
    emit(state.copyWith(createStatus: ManageVehicleStatus.loading));
    try {
      final vehicle = event.vehicle
          .copyWith(status: TicketStatus.active, updatedAt: DateTime.now());
      final newVehicle =
          await vehicleRepository.comfirmRegisterVehicle(vehicle);
      // delay 2s
      await Future.delayed(const Duration(seconds: 2));

      //fiind and replace
      final list = state.list.map((e) {
        if (e.id == newVehicle.id) {
          return newVehicle;
        }
        return e;
      }).toList();

      emit(
        state
            .copyWith(createStatus: ManageVehicleStatus.loaded, list: list)
            .emptySelected(),
      );
    } catch (e) {
      emit(
        state.copyWith(
          createStatus: ManageVehicleStatus.error,
          message: e.toString(),
        ),
      );
    }
  }

  void _onManageVehicleConfirmRegister(
    ManageVehicleConfirmRegister event,
    Emitter<ManageVehicleState> emit,
  ) async {
    // emit(state.copyWith(status: ManageVehicleStatus.loading));
    try {
      final ticket = state.list.firstWhere((e) => e.id == event.ticketId);
      emit(state.copyWith(ticketSelect: ticket));
    } catch (e) {
      emit(state.copyWith(status: ManageVehicleStatus.error));
    }
  }

  void _onManageVehicleUpdateStatus(
    ManageVehicleUpdateStatus event,
    Emitter<ManageVehicleState> emit,
  ) async {
    // emit(state.copyWith(status: ManageVehicleStatus.loading));
    try {
      final newTicket = await vehicleRepository.updateVehicleStatus(
          event.ticketId, event.status.toJson());
      final list = state.list.map((e) {
        if (e.id == event.ticketId) {
          return newTicket;
        }
        return e;
      }).toList();
      emit(state.copyWith(status: ManageVehicleStatus.loaded, list: list));
    } catch (e) {
      emit(state.copyWith(status: ManageVehicleStatus.error));
    }
  }
}
