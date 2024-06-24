import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String productId;
  int quantity;
  final String? shopId;
  final String? shopName;
  final String? title;
  final String? imageUrl;
  double price;
  bool checked;

  CartItem({
    required this.productId,
    this.quantity = 1,
    this.title,
    this.imageUrl,
    this.price = 0.0,
    this.shopId,
    this.shopName,
    this.checked = false,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'] ?? '',
      quantity: json['quantity'] ?? 1,
      imageUrl: json['imageUrl'] ?? '',
      // title: json['title'] ?? '',
      // price: json['price'] ?? 0.0,
      // shopId: json['shopId'] ?? '',
      // shopName: json['shopName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': productId,
      'title': title,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'price': price,
      'shopId': shopId,
      'shopName': shopName,
    };
  }

  CartItem copyWith({
    String? productId,
    String? title,
    String? imageUrl,
    int? quantity,
    double? price,
    String? shopId,
    String? shopName,
    bool? isDelete,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
      checked: isDelete ?? this.checked,
    );
  }

  @override
  List<Object?> get props =>
      [productId, title, quantity, price, shopId, shopName, imageUrl, checked];
}
