import 'package:apartment_managage/data/datasources/service/booking_service_remote.dart';
import 'package:apartment_managage/domain/models/service/booking_service.dart';
import 'package:apartment_managage/domain/models/service/enum_service.dart';
import 'package:apartment_managage/domain/repository/service/booking_repository.dart';
import 'package:apartment_managage/utils/utils.dart';

class BookingRepositoryIml implements BookingRepository {
  final BookingServiceRemoteDataSource remoteDate;

  BookingRepositoryIml(this.remoteDate);

  @override
  Future<BookingService?> add({required BookingService bookingService}) async {
    return remoteDate.add(booking: bookingService);
  }

  @override
  Future<void> delete({required String id}) async {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<BookingService>> getAll() async {
    return await remoteDate.getAll();
  }

  @override
  Future<List<BookingService>> getAllByUserId({required String userId}) async {
    return await remoteDate.getAllByUserId(userId: userId);
  }

  @override
  Future<void> updateStatus(
      {required String id, required BookingStatus status}) async {
    return await remoteDate.updateStatus(id: id, status: status);
  }

  @override
  Future<List<BookingService>> getScheduleInDay(DateTime date) async {
    final string = TextFormat.formatDate(date);
    return await remoteDate.getScheduleInDay(string);
  }
}
