import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apartment_managage/domain/models/ecom/product_model.dart';
import 'package:apartment_managage/utils/firebase.dart';
import 'package:apartment_managage/utils/logger.dart';

class ProductRemote {
  final _firebaseAuth = FirebaseAuth.instance;

  // CRUD product

  Future<ProductModel> add(
      {required String name,
      required String description,
      required double price,
      String? imageUrl}) async {
    try {
      String owner = _firebaseAuth.currentUser!.uid;
      final pos = await productRef.add({
        'name': name,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'ownerId': owner,
        'createdAt': Timestamp.now(),
      });
      return ProductModel(
        id: pos.id,
        name: name,
        description: description,
        price: price,
        imageUrl: imageUrl,
        ownerId: owner,
      );
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }

  Future<ProductModel> get({required String id}) async {
    try {
      final doc = await productRef.doc(id).get();
      return ProductModel.fromDocumentSnapshot(doc);
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }

  Future<void> update(
      {required String id,
      required String name,
      required String description,
      required double price,
      required String ownerId,
      required String imageUrl}) async {
    try {
      await productRef.doc(id).update({
        'name': name,
        'description': description,
        'price': price,
        'image_urrl': imageUrl,
        'ownerId': ownerId,
        'updated_at': Timestamp.now(),
      });
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }

  Future<void> delete({required String id}) async {
    try {
      await productRef.doc(id).delete();
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }

  Future<List<ProductModel>> getAll() async {
    try {
      final querySnapshot = await productRef.get();
      return querySnapshot.docs
          .map((e) => ProductModel.fromDocumentSnapshot(e))
          .toList();
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }
}
