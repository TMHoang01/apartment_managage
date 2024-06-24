import 'package:apartment_managage/domain/models/ecom/product_model.dart';

abstract class ProductRepository {
  // CRUD product
  Future<ProductModel> add(
      {required String name,
      required String description,
      required double price,
      String? imageUrl});

  Future<ProductModel> get({required String id});

  Future<void> update(
      {required String id,
      required String name,
      required String description,
      required double price,
      required String ownerId,
      required String imageUrl});

  Future<void> delete({required String id});

  Future<List<ProductModel>> getAll();
}
