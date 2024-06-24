part of 'service_booking_bloc.dart';

sealed class ServiceBookingEvent extends Equatable {
  const ServiceBookingEvent();

  @override
  List<Object> get props => [];
}

class ServiceBookingStarted extends ServiceBookingEvent {}

class ServiceBookingStartedByUser extends ServiceBookingEvent {}

class ServiceBookingUpdateStatus extends ServiceBookingEvent {
  final String? bookingId;
  final BookingStatus? status;

  ServiceBookingUpdateStatus(this.bookingId, this.status);

  @override
  List<Object> get props => [];
}

class ServiceBookingDetailStarted extends ServiceBookingEvent {
  final String? bookingId;

  ServiceBookingDetailStarted(this.bookingId);

  @override
  List<Object> get props => [];
}
