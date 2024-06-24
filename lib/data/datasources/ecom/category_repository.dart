import 'package:apartment_managage/domain/models/ecom/category_model.dart';
import 'package:apartment_managage/domain/repository/ecom/category_repository.dart';
import 'package:apartment_managage/utils/firebase.dart';
import 'package:apartment_managage/utils/logger.dart';

class CategoryRemote extends CategoryRepository {
  // CRUD product
  @override
  Future<void> add(
      {required String title,
      required String description,
      required String price,
      required String imageUrl}) async {
    try {
      await categoryRef.add({
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
      });
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> update(
      {required String id,
      required String title,
      required String description,
      required String price,
      required String userCreated,
      required String imageUrl}) async {
    try {
      await categoryRef.doc(id).update({
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
      });
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> delete({required String id}) async {
    try {
      await categoryRef.doc(id).delete();
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<Category>> getAll() async {
    try {
      final querySnapshot = await categoryRef.get();
      return querySnapshot.docs
          .map((e) => Category.fromDocumentSnapshot(e))
          .toList();
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }
}
