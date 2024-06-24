part of 'users_bloc.dart';

sealed class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object> get props => [];
}

final class UsersInitial extends UsersState {}

final class UsersLoading extends UsersState {}

final class UsersLoaded extends UsersState {
  final List<UserModel> users;

  UsersLoaded(this.users);

  @override
  List<Object> get props => [users];
}

final class UsersError extends UsersState {
  final String message;

  UsersError(this.message);

  @override
  List<Object> get props => [message];
}
