part of 'guest_access_bloc.dart';

enum GuestAccessStatus { initial, loading, loaded, error }

class GuestAccessState extends Equatable {
  final GuestAccessStatus status;
  final List<GuestAccess> list;
  final GuestAccess? select;
  final GuestAccessStatus? statusProcess;
  final String? message;

  const GuestAccessState(
      {this.status = GuestAccessStatus.initial,
      this.list = const [],
      this.select,
      this.statusProcess,
      this.message});

  GuestAccessState copyWith(
      {GuestAccessStatus? status,
      List<GuestAccess>? list,
      GuestAccess? select,
      GuestAccessStatus? statusProcess,
      String? message}) {
    return GuestAccessState(
        status: status ?? this.status,
        list: list ?? this.list,
        select: select ?? this.select,
        statusProcess: statusProcess ?? this.statusProcess,
        message: message);
  }

  @override
  List<Object?> get props => [status, list, select, statusProcess, message];
}
