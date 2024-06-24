import 'package:apartment_managage/domain/models/ecom/category_model.dart';

abstract class CategoryRepository {
  // CRUD product
  Future<void> add(
      {required String title,
      required String description,
      required String price,
      required String imageUrl});
  Future<void> update(
      {required String id,
      required String title,
      required String description,
      required String price,
      required String userCreated,
      required String imageUrl});
  Future<void> delete({required String id});
  Future<List<Category>> getAll();
}
