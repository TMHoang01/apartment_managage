import 'package:apartment_managage/data/datasources/ecom/cart_remote.dart';
import 'package:apartment_managage/domain/models/ecom/cart.dart';
import 'package:apartment_managage/domain/models/ecom/cart_item.dart';
import 'package:apartment_managage/domain/repository/ecom/cart_repository.dart';

class CartRepositoryIml extends CartRepository {
  final CartRemote _cartService;
  CartRepositoryIml(CartRemote cartService) : _cartService = cartService;
  @override
  Future<void> add({required CartModel cartModel}) async {}

  @override
  Future<CartModel> get({required String userdId}) async {
    return await _cartService.get(userdId: userdId);
  }

  @override
  Future<void> deleteItem(
      {required String id, required String productId}) async {
    await _cartService.deleteItem(id: id, productId: productId);
  }

  @override
  Future<void> update(
      {required String id, required List<CartItem> cartItems}) async {
    await _cartService.update(id: id, cartItems: cartItems);
  }

  Future<bool> checkProductInCart(String id, String productId) async {
    return await _cartService.checkProductInCart(id, productId);
  }

  @override
  Future<void> addCartItem(
      {required String id, required CartItem cartItem}) async {
    await _cartService.addCartItem(id: id, cartItem: cartItem);
  }
}
