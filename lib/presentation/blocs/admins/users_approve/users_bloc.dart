import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:apartment_managage/domain/models/user_model.dart';
import 'package:apartment_managage/domain/repository/user_repository.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersApproveBloc extends Bloc<UsersApproveEvent, UsersApproveState> {
  UserRepository _userRepository;
  UsersApproveBloc(UserRepository userRepository)
      : _userRepository = userRepository,
        super(UsersApproveInitial()) {
    on<UsersApproveEvent>((event, emit) {});
    on<UsersApproveGetAll>(_getAllUsers);
    on<UsersApproveAcceptUser>(_acceptUser);
    on<UsersSwitchLockAccount>(_switchLockAccount);
    on<UsersGetListNotInClude>(_getListNotInClude);
  }

  void _getAllUsers(
      UsersApproveGetAll event, Emitter<UsersApproveState> emit) async {
    try {
      emit(UsersApproveLoading());
      final user = await _userRepository.getUserPending();
      emit(UsersApproveLoaded(user));
    } catch (e) {
      emit(UsersApproveError(e.toString()));
    }
  }

  void _acceptUser(
      UsersApproveAcceptUser event, Emitter<UsersApproveState> emit) async {
    try {
      if (state is UsersApproveLoaded) {
        final users = (state as UsersApproveLoaded).users;
        // emit(UsersLoading());

        await _userRepository.updateStatus(event.userId, event.status.name);
        final newUsers = users
            .map((e) =>
                e.id == event.userId ? e.copyWith(status: event.status) : e)
            .toList();
        emit(UsersApproveLoaded(newUsers));
      }
    } catch (e) {
      emit(UsersApproveError(e.toString()));
    }
  }

  void _switchLockAccount(
      UsersSwitchLockAccount event, Emitter<UsersApproveState> emit) async {}

  void _getListNotInClude(
      UsersGetListNotInClude event, Emitter<UsersApproveState> emit) async {
    try {
      final users =
          await _userRepository.getListNotInClude(event.userIds ?? []);
      emit(UsersApproveLoaded(users));
    } catch (e) {
      emit(UsersApproveError(e.toString()));
    }
  }
}
