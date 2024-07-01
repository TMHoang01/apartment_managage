import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:apartment_managage/domain/models/user_model.dart';
import 'package:apartment_managage/domain/repository/user_repository.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UserRepository _userRepository;
  UsersBloc(UserRepository userRepository)
      : _userRepository = userRepository,
        super(UsersInitial()) {
    on<UsersEvent>((event, emit) {});
    on<UsersGetAllUsers>(_getAllUsers);
    on<UsersAcceptUser>(_acceptUser);
    on<UsersSwitchLockAccount>(_switchLockAccount);
    on<UsersGetListNotInClude>(_getListNotInClude);
  }

  void _getAllUsers(UsersGetAllUsers event, Emitter<UsersState> emit) async {
    try {
      emit(UsersLoading());
      final user = await _userRepository.getListUsers(event.type ?? 'resident');
      emit(UsersLoaded(user));
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  void _acceptUser(UsersAcceptUser event, Emitter<UsersState> emit) async {
    try {
      if (state is UsersLoaded) {
        final users = (state as UsersLoaded).users;
        // emit(UsersLoading());

        await _userRepository.updateStatus(event.userId, event.status.name);
        final newUsers = users
            .map((e) =>
                e.id == event.userId ? e.copyWith(status: event.status) : e)
            .toList();
        emit(UsersLoaded(newUsers));
      }
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  void _switchLockAccount(
      UsersSwitchLockAccount event, Emitter<UsersState> emit) async {}

  void _getListNotInClude(
      UsersGetListNotInClude event, Emitter<UsersState> emit) async {
    try {
      final users =
          await _userRepository.getListNotInClude(event.userIds ?? []);
      emit(UsersLoaded(users));
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }
}
