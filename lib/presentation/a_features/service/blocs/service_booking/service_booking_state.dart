part of 'service_booking_bloc.dart';

enum ServiceBookingStatus { initial, loading, loaded, error }

class ServiceBookingState extends Equatable {
  const ServiceBookingState({
    this.status = ServiceBookingStatus.initial,
    this.list = const <BookingService>[],
    this.bookingSelected,
    this.message = '',
  });

  final ServiceBookingStatus status;
  final List<BookingService> list;
  final BookingService? bookingSelected;
  final String message;

  ServiceBookingState copyWith({
    ServiceBookingStatus? status,
    List<BookingService>? list,
    BookingService? bookingSelected,
    String? message,
  }) {
    return ServiceBookingState(
      status: status ?? this.status,
      list: list ?? this.list,
      bookingSelected: bookingSelected ?? this.bookingSelected,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        status,
        list,
        bookingSelected,
        message,
      ];
}
