import 'package:firebase_auth/firebase_auth.dart';
import 'package:apartment_managage/domain/models/service/service.dart';
import 'package:apartment_managage/utils/firebase.dart';
import 'package:apartment_managage/utils/logger.dart';

abstract class ServiceRemoteDataSource {
  Future<String?> add({required ServiceModel service});
  Future<void> update({required ServiceModel service});
  Future<void> delete({required String id});

  Stream<List<ServiceModel>> getAll();
}

class ServiceRemoteDataSourceImpl implements ServiceRemoteDataSource {
  final colection = serviceRef;
  @override
  Future<String?> add({required ServiceModel service}) async {
    try {
      final response = await colection.add(service.toJson());
      return response.id;
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> update({required ServiceModel service}) async {
    try {
      await colection.doc(service.id).update(service.toJson());
    } on FirebaseException catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> delete({required String id}) async {
    try {
      await colection.doc(id).delete();
    } on FirebaseException catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Stream<List<ServiceModel>> getAll() async* {
    try {
      final response =
          colection.orderBy('createdAt', descending: true).snapshots();
      yield* response.map((event) => event.docs.map((e) {
            final data = e.data() as Map<String, dynamic>;
            return ServiceModel.fromDocumentSnapshot(e);
          }).toList());
      yield [];
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }
}
