import 'package:apartment_managage/domain/models/guest_access/guest_access.dart';
import 'package:apartment_managage/domain/repository/guest_access/guest_access_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'guest_access_event.dart';
part 'guest_access_state.dart';

class GuestAccessBloc extends Bloc<GuestAccessEvent, GuestAccessState> {
  final GuestAccessRepository guestAccessRepository;
  GuestAccessBloc(this.guestAccessRepository)
      : super(const GuestAccessState()) {
    on<GuestAccessEvent>((event, emit) {});
    on<GuestAccessEventStarted>(_onStarted);
    on<GuestAccessEventDetailStated>(_onDetailStated);
    on<GuestAccessEventUpdateStatus>(_onUpdateStatus);
  }

  void _onStarted(
      GuestAccessEventStarted event, Emitter<GuestAccessState> emit) async {
    emit(state.copyWith(status: GuestAccessStatus.loading));
    try {
      final list = await guestAccessRepository.getByDate(DateTime.now());
      emit(state.copyWith(status: GuestAccessStatus.loaded, list: list));
    } catch (e) {
      emit(
        state.copyWith(status: GuestAccessStatus.error, message: e.toString()),
      );
    }
  }

  void _onDetailStated(GuestAccessEventDetailStated event,
      Emitter<GuestAccessState> emit) async {
    emit(state.copyWith(statusProcess: GuestAccessStatus.loading));
    try {
      // final guestAccess = await guestAccessRepository.getById(event.id);
      final guestAccess =
          state.list.firstWhere((element) => element.id == event.id);
      emit(state.copyWith(
          statusProcess: GuestAccessStatus.loaded, select: guestAccess));
    } catch (e) {
      emit(state.copyWith(
          statusProcess: GuestAccessStatus.error, message: e.toString()));
    }
  }

  void _onUpdateStatus(
      GuestAccessEventUpdateStatus event, Emitter<GuestAccessState> emit) {
    emit(state.copyWith(statusProcess: GuestAccessStatus.loading));
    try {
      guestAccessRepository.update(event.guestAccess);
      final list = state.list
          .map((e) => e.id == event.guestAccess.id ? event.guestAccess : e)
          .toList();

      emit(state.copyWith(
        statusProcess: GuestAccessStatus.loaded,
        list: list,
        select: event.guestAccess,
      ));
    } catch (e) {
      emit(state.copyWith(
          statusProcess: GuestAccessStatus.error, message: e.toString()));
    }
  }
}
