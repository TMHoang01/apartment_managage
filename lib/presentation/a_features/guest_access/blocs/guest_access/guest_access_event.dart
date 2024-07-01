part of 'guest_access_bloc.dart';

sealed class GuestAccessEvent extends Equatable {
  const GuestAccessEvent();

  @override
  List<Object> get props => [];
}

class GuestAccessEventStarted extends GuestAccessEvent {}

class GuestAccessCreateSubmit extends GuestAccessEvent {
  final GuestAccess guestAccess;

  const GuestAccessCreateSubmit(this.guestAccess);

  @override
  List<Object> get props => [guestAccess];
}

class GuestAccessEventDetailStated extends GuestAccessEvent {
  final String id;

  const GuestAccessEventDetailStated(this.id);

  @override
  List<Object> get props => [id];
}

class GuestAccessEventCancel extends GuestAccessEvent {
  final String id;

  const GuestAccessEventCancel(this.id);

  @override
  List<Object> get props => [id];
}

class GuestAccessEventUpdateStatus extends GuestAccessEvent {
  final GuestAccess guestAccess;

  const GuestAccessEventUpdateStatus(this.guestAccess);

  @override
  List<Object> get props => [guestAccess];
}
