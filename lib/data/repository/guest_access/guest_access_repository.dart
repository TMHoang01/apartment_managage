import 'package:apartment_managage/data/datasources/guest_access/guest_access_remote.dart';
import 'package:apartment_managage/domain/models/guest_access/guest_access.dart';
import 'package:apartment_managage/domain/repository/guest_access/guest_access_repository.dart';
import 'package:apartment_managage/utils/utils.dart';

class GuestAccessRepositoryImpl implements GuestAccessRepository {
  final GuestAccessRemoteDataSource remoteDate;

  GuestAccessRepositoryImpl(this.remoteDate);

  @override
  Future<GuestAccess?> add(GuestAccess guestAccess) async {
    return remoteDate.add(guestAccess);
  }

  @override
  Future<GuestAccess?> getById(String id) async {
    final guestAccessLocal = GuestAccess();
    if (guestAccessLocal.id != null) {
      return guestAccessLocal;
    } else {
      logger.i('get guestAccess from remote');
    }
  }

  @override
  Future<void> delete(String id) async {
    return remoteDate.delete(id);
  }

  @override
  Future<List<GuestAccess>> getAll(
      {DateTime? lastCreateAt,
      int limit = 15,
      Map<String, String>? filter}) async {
    return remoteDate.getAll(
        lastCreateAt: lastCreateAt, limit: limit, filter: filter);
  }

  @override
  Future<List<GuestAccess>> getByDate(DateTime time) async {
    return remoteDate.getByDate(time);
  }

  @override
  Future<void> update(guestAccess) {
    return remoteDate.update(guestAccess);
  }
}
