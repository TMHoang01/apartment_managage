part of 'user_detail_bloc.dart';

enum UserDatailStatus { inital, loading, loaded, error }

class UserDetailState extends Equatable {
  final UserModel? item;
  final String? message;
  final UserDatailStatus? status;
  const UserDetailState({this.item, this.message, this.status});

  UserDetailState copyWith(
      {UserModel? item, String? message, UserDatailStatus? status}) {
    return UserDetailState(
      item: item ?? this.item,
      message: message,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [item, message, status];
}
