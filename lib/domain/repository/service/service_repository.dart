import 'package:apartment_managage/domain/models/service/service.dart';

export 'package:apartment_managage/data/repository/service/service_repository.dart';

abstract class ServiceRepository {
  // CRUD service
  Future<ServiceModel> add({required ServiceModel service});
  Future<void> update({required ServiceModel service});
  Future<void> delete({required String id});
  Stream<List<ServiceModel>> getAll();
}
