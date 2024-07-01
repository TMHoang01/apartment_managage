part of 'users_bloc.dart';

sealed class UsersApproveEvent extends Equatable {
  const UsersApproveEvent();

  @override
  List<Object> get props => [];
}

class UsersApproveGetAll extends UsersApproveEvent {}

class UsersApproveAcceptUser extends UsersApproveEvent {
  final String userId;
  final StatusUser status;

  UsersApproveAcceptUser(this.userId, this.status);

  @override
  List<Object> get props => [userId, status];
}

class UsersSwitchLockAccount extends UsersApproveEvent {
  final String userId;
  final bool isLock;

  UsersSwitchLockAccount(this.userId, this.isLock);

  @override
  List<Object> get props => [userId, isLock];
}

class UsersGetUserById extends UsersApproveEvent {
  final String userId;

  UsersGetUserById(this.userId);

  @override
  List<Object> get props => [userId];
}

class UsersLoadMore extends UsersApproveEvent {
  UsersLoadMore();

  @override
  List<Object> get props => [];
}

class UsersGetListNotInClude extends UsersApproveEvent {
  final List<String>? userIds;

  UsersGetListNotInClude(this.userIds);

  @override
  List<Object> get props => [];
}
