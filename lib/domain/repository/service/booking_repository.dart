import 'package:apartment_managage/domain/models/service/booking_service.dart';
import 'package:apartment_managage/domain/models/service/enum_service.dart';

export 'package:apartment_managage/data/repository/service/booking_repository.dart';

abstract class BookingRepository {
  Future<BookingService?> add({required BookingService bookingService});
  Future<void> updateStatus(
      {required String id, required BookingStatus status});
  Future<void> delete({required String id});
  Future<List<BookingService>> getAllByUserId({required String userId});
  Future<List<BookingService>> getAll();

  Future<List<BookingService>> getScheduleInDay(DateTime date);
}
