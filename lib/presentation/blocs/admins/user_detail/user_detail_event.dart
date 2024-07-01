part of 'user_detail_bloc.dart';

sealed class UserDetailEvent extends Equatable {
  const UserDetailEvent();

  @override
  List<Object> get props => [];
}

class UserDetailStarted extends UserDetailEvent {
  final String? id;
  final UserModel? user;

  const UserDetailStarted({this.id, this.user});
}

class UserDetailUpdateStatus extends UserDetailEvent {
  final String status;
  const UserDetailUpdateStatus(this.status);
}
