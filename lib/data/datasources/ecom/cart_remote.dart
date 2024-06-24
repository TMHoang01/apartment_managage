import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apartment_managage/domain/models/ecom/cart.dart';
import 'package:apartment_managage/domain/models/ecom/cart_item.dart';
import 'package:apartment_managage/domain/models/ecom/product_model.dart';
import 'package:apartment_managage/utils/firebase.dart';
import 'package:apartment_managage/utils/logger.dart';

class CartRemote {
  Future<String?> add({required CartModel cartModel}) async {
    try {
      final cart = await cartRef.add(
        {
          'user_id': cartModel.userId,
          'items': cartModel.items
              .map((e) => {
                    'productId': e.productId,
                    'quantity': e.quantity,
                  })
              .toList() as List<Map<String, dynamic>>,
          'status': cartModel.status,
          'created_at': cartModel.createdAt,
        },
      );
      return cart.id;
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }

  Future<CartModel> get({required String userdId}) async {
    try {
      final querySnapshotCart =
          await cartRef.where('user_id', isEqualTo: userdId).get();
      final doc = querySnapshotCart.docs.firstOrNull;
      if (doc != null) {
        CartModel cart = CartModel.fromDocumentSnapshot(doc);
        // load product data
        final itemsId = (cart.items).map((e) => e.productId).toList();
        if (itemsId.isEmpty) {
          return cart;
        }
        final productsQuery = await productRef
            .where(FieldPath.documentId, whereIn: itemsId)
            .get();
        final productsData = productsQuery.docs
            .map((e) => ProductModel.fromDocumentSnapshot(e))
            .toList();
        final items = cart.items.map(
          (e) {
            final indexItem =
                productsData.indexWhere((element) => element.id == e.productId);
            if (indexItem == -1) {
              return e.copyWith(isDelete: true);
            }
            final product = productsData[indexItem];
            return e.copyWith(
              title: product.name,
              imageUrl: product.imageUrl,
              price: product.price,
            );
          },
        ).toList();
        cart = cart.copyWith(items: items);
        return cart;
      }
      final newCart = CartModel.empty(userdId);
      final idCart = await add(cartModel: newCart);
      return newCart.copyWith(id: idCart);
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }

  Future<void> deleteItem(
      {required String id, required String productId}) async {
    try {
      cartRef.doc(id).update({
        'items': FieldValue.arrayRemove([
          {'productId': productId}
        ])
      });
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }

  Future<void> update(
      {required String id, required List<CartItem> cartItems}) async {
    List<Map<String, dynamic>> itemsData = cartItems
        .map((item) => {
              'productId': item.productId,
              'quantity': item.quantity,
            })
        .toList();

    if (cartItems.isEmpty) {
      await cartRef.doc(id).update({'items': []});
    } else {
      await cartRef.doc(id).update({'items': itemsData});
    }
  }

  double getTotalPrice(List<CartItem> cartItems) {
    double calculatedPrice = 0;
    for (var item in cartItems) {
      calculatedPrice += (item.quantity * item.price);
    }
    return calculatedPrice;
  }

  Future<bool> checkProductInCart(String id, String productId) async {
    try {
      final doc = await cartRef.doc(id).get();
      final data = doc.data() as Map<String, dynamic>;
      final items = data['items'] as List;
      return items.any((element) => element['productId'] == productId);
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }

  Future<void> addCartItem(
      {required String id, required CartItem cartItem}) async {
    try {
      final doc = await cartRef.doc(id).get();
      final data = doc.data() as Map<String, dynamic>;
      final items = data['items'] as List;
      final index = items
          .indexWhere((element) => element['productId'] == cartItem.productId);
      if (index != -1) {
        items[index]['quantity'] = cartItem.quantity;
        await cartRef.doc(id).update({'items': items});
      } else {
        await cartRef.doc(id).update({
          'items': FieldValue.arrayUnion([
            {'productId': cartItem.productId, 'quantity': cartItem.quantity}
          ])
        });
      }
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }
}
