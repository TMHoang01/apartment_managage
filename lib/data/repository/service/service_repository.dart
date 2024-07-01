import 'package:apartment_managage/data/datasources/service/service_remote.dart';
import 'package:apartment_managage/domain/models/service/service.dart';
import 'package:apartment_managage/domain/repository/service/service_repository.dart';

class ServiceRepositoryImpl extends ServiceRepository {
  final ServiceRemoteDataSource serviceRemoteDataSource;

  ServiceRepositoryImpl(this.serviceRemoteDataSource);

  @override
  Future<ServiceModel> add({required ServiceModel service}) async {
    return service.copyWith(
        id: await serviceRemoteDataSource.add(service: service));
  }

  @override
  Future<void> update({required ServiceModel service}) async {
    return serviceRemoteDataSource.update(service: service);
  }

  @override
  Future<void> delete({required String id}) async {
    return serviceRemoteDataSource.delete(id: id);
  }

  @override
  Stream<List<ServiceModel>> getAll() async* {
    yield* serviceRemoteDataSource.getAll();
  }
}
