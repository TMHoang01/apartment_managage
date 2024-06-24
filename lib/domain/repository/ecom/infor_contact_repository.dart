import 'package:apartment_managage/domain/models/ecom/infor_contact.dart';

abstract class InforContactRepository {
  // CRUD product
  Future<InforContactModel> add({required InforContactModel inforContactModel});

  Future<void> update(
      {required String id, required InforContactModel inforContactModel});

  Future<InforContactModel?> findByUserId({required String userId});

  Future<void> delete({required String id});
}
