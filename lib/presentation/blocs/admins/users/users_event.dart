part of 'users_bloc.dart';

sealed class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object> get props => [];
}

class UsersGetAllUsers extends UsersEvent {}

class UsersAcceptUser extends UsersEvent {
  final String userId;
  final StatusUser status;

  UsersAcceptUser(this.userId, this.status);

  @override
  List<Object> get props => [userId, status];
}

class UsersSwitchLockAccount extends UsersEvent {
  final String userId;
  final bool isLock;

  UsersSwitchLockAccount(this.userId, this.isLock);

  @override
  List<Object> get props => [userId, isLock];
}

class UsersGetUserById extends UsersEvent {
  final String userId;

  UsersGetUserById(this.userId);

  @override
  List<Object> get props => [userId];
}

class UsersLoadMore extends UsersEvent {
  UsersLoadMore();

  @override
  List<Object> get props => [];
}

class UsersGetListNotInClude extends UsersEvent {
  final List<String>? userIds;

  UsersGetListNotInClude(this.userIds);

  @override
  List<Object> get props => [];
}
