part of 'users_bloc.dart';

sealed class UsersApproveState extends Equatable {
  const UsersApproveState();

  @override
  List<Object> get props => [];
}

final class UsersApproveInitial extends UsersApproveState {}

final class UsersApproveLoading extends UsersApproveState {}

final class UsersApproveLoaded extends UsersApproveState {
  final List<UserModel> users;

  UsersApproveLoaded(this.users);

  @override
  List<Object> get props => [users];
}

final class UsersApproveError extends UsersApproveState {
  final String message;

  UsersApproveError(this.message);

  @override
  List<Object> get props => [message];
}
