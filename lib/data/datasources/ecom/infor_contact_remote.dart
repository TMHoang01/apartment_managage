import 'package:apartment_managage/domain/models/ecom/infor_contact.dart';
import 'package:apartment_managage/utils/firebase.dart';
import 'package:apartment_managage/utils/logger.dart';

class InforContactRemote {
  Future<String?> add(InforContactModel inforContactModel) async {
    try {
      final doc = await inforContactRef.add(inforContactModel.toJson());
      return doc.id;
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }

  Future<InforContactModel?> findByUserId({required String userId}) async {
    try {
      final querySnapshot =
          await inforContactRef.where('userId', isEqualTo: userId).get();
      final doc = querySnapshot.docs.firstOrNull;
      if (doc != null) {
        return InforContactModel.fromDocumentSnapshot(doc);
      }
      return null;
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }

  Future<void> update(
      {required String id,
      required InforContactModel inforContactModel}) async {
    try {
      await inforContactRef.doc(id).update(inforContactModel.toJson());
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }
}
