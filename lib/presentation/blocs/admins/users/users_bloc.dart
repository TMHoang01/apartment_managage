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
    on<UsersLoadMore>(_loadMore);
    on<UsersGetListNotInClude>(_getListNotInClude);
  }

  void _getAllUsers(UsersGetAllUsers event, Emitter<UsersState> emit) async {
    try {
      emit(UsersLoading());
      final users = await _userRepository.getUserPending();
      emit(UsersLoaded(users));
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

  void _loadMore(UsersLoadMore event, Emitter<UsersState> emit) async {
    try {
      if (state is UsersLoaded) {
        final users = (state as UsersLoaded).users;
        final query = UsersQuery(
          page: users.length ~/ 20 + 1,
          pageSize: 20,
        );
        final newUsers = await _userRepository.getUsersQuery(query);
        emit(UsersLoaded([...users, ...newUsers]));
      }
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

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

class UsersQuery {
  final String? search;
  final int? page;
  final int? pageSize;
  final String? lastId;
  final String? sort;
  final String? order;
  final String? status;

  UsersQuery(
      {this.search,
      this.page = 1,
      this.pageSize = 20,
      this.lastId,
      this.sort,
      this.order = 'desc',
      this.status});
}
