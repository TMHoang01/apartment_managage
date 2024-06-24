import 'package:apartment_managage/data/datasources/ecom/infor_contact_remote.dart';
import 'package:apartment_managage/domain/models/ecom/infor_contact.dart';
import 'package:apartment_managage/domain/repository/ecom/infor_contact_repository.dart';

class InforContactRepositoryIml extends InforContactRepository {
  final InforContactRemote _inforContactRemote;
  InforContactRepositoryIml({required InforContactRemote inforContactRemote})
      : _inforContactRemote = inforContactRemote;

  @override
  Future<InforContactModel> add(
      {required InforContactModel inforContactModel}) async {
    try {
      final id = await _inforContactRemote.add(inforContactModel);

      return inforContactModel.copyWith(id: id);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> delete({required String id}) async {
    throw UnimplementedError();
  }

  @override
  Future<InforContactModel?> findByUserId({required String userId}) async {
    return await _inforContactRemote.findByUserId(userId: userId);
  }

  @override
  Future<void> update(
      {required String id,
      required InforContactModel inforContactModel}) async {
    return await _inforContactRemote.update(
        id: id, inforContactModel: inforContactModel);
  }
}
