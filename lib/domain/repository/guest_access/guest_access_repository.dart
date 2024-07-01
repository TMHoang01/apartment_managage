import 'package:apartment_managage/domain/models/guest_access/guest_access.dart';
import 'package:apartment_managage/utils/utils.dart';

export 'package:apartment_managage/domain/repository/guest_access/guest_access_repository.dart';

abstract class GuestAccessRepository {
  Future<GuestAccess?> add(GuestAccess guestAccess);
  Future<GuestAccess?> getById(String id);
  Future<void> update(guestAccess);
  Future<void> delete(String id);
  Future<List<GuestAccess>> getAll(
      {DateTime? lastCreateAt,
      int limit = LIMIT_PAGE,
      Map<String, String>? filter});

  Future<List<GuestAccess>> getByDate(DateTime time);
}
