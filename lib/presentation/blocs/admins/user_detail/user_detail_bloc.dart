import 'package:apartment_managage/domain/models/user_model.dart';
import 'package:apartment_managage/domain/repository/user_repository.dart';
import 'package:apartment_managage/utils/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'user_detail_event.dart';
part 'user_detail_state.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  UserRepository userRepository;

  UserDetailBloc(this.userRepository) : super(UserDetailState()) {
    on<UserDetailEvent>((event, emit) {});
    on<UserDetailStarted>(_started);
    on<UserDetailUpdateStatus>(_updatedStatus);
  }

  Future<void> _started(
      UserDetailStarted event, Emitter<UserDetailState> emit) async {
    try {
      emit(state.copyWith(status: UserDatailStatus.loading));

      if (event.user != null) {
        emit(state.copyWith(item: event.user, status: UserDatailStatus.loaded));

        return;
      }
    } catch (e) {
      logger.e(e);
      emit(state.copyWith(
        status: UserDatailStatus.error,
        message: e.toString(),
      ));

      throw new Exception(e.toString());
    }
  }

  Future<void> _updatedStatus(
      UserDetailUpdateStatus event, Emitter<UserDetailState> emit) async {
    try {
      final id = state.item?.id;
      if (id == null) {
        emit(state.copyWith(
          message: 'Invalid Id',
          status: UserDatailStatus.error,
        ));
        return;
      }
      emit(
        state.copyWith(
          status: UserDatailStatus.loading,
        ),
      );
      await userRepository.updateStatus(id, event.status);
      final item = state.item?.copyWith(
        status: StatusUser.fromJson(event.status),
      );
      emit(
        state.copyWith(
          item: item,
          status: UserDatailStatus.loaded,
        ),
      );
    } catch (e) {
      logger.e(e);
      emit(state.copyWith(
        message: e.toString(),
        status: UserDatailStatus.error,
      ));
      // throw new Exception(e.toString());
    }
  }
}
