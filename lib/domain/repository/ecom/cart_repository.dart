import 'package:apartment_managage/domain/models/ecom/cart.dart';
import 'package:apartment_managage/domain/models/ecom/cart_item.dart';

abstract class CartRepository {
  Future<void> add({required CartModel cartModel});

  Future<CartModel> get({required String userdId});

  Future<void> addCartItem({required String id, required CartItem cartItem});

  Future<void> update({required String id, required List<CartItem> cartItems});

  Future<void> deleteItem({required String id, required String productId});
}
