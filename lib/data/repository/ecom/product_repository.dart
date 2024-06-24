import 'package:apartment_managage/data/datasources/ecom/product_repository.dart';
import 'package:apartment_managage/domain/models/ecom/product_model.dart';
import 'package:apartment_managage/domain/repository/ecom/product_repository.dart';

class ProductRepositoryIml extends ProductRepository {
  final ProductRemote _productRemote;

  ProductRepositoryIml(ProductRemote productRemote)
      : _productRemote = productRemote;
  // CRUD product
  @override
  Future<ProductModel> add(
      {required String name,
      required String description,
      required double price,
      String? imageUrl}) async {
    return _productRemote.add(
      name: name,
      description: description,
      price: price,
      imageUrl: imageUrl,
    );
  }

  @override
  Future<ProductModel> get({required String id}) async {
    return _productRemote.get(id: id);
  }

  @override
  Future<void> update(
      {required String id,
      required String name,
      required String description,
      required double price,
      required String ownerId,
      required String imageUrl}) async {
    return _productRemote.update(
      id: id,
      name: name,
      description: description,
      price: price,
      ownerId: ownerId,
      imageUrl: imageUrl,
    );
  }

  @override
  Future<void> delete({required String id}) async {
    return _productRemote.delete(id: id);
  }

  @override
  Future<List<ProductModel>> getAll() async {
    return _productRemote.getAll();
  }
}
