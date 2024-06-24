class ProductModel {
  String? name;
  String? description;
  double? price;
  String? imageUrl;
  bool? isInMyCart;
  String? id;
  String? ownerId;

  ProductModel({
    this.name,
    this.description,
    this.price,
    this.imageUrl,
    this.isInMyCart,
    this.id,
    this.ownerId,
  });

  factory ProductModel.fromDocumentSnapshot(doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    dynamic firebaseData = data['price'];
    double? doubleValue;
    if (firebaseData != null) {
      if (firebaseData is int) {
        doubleValue = firebaseData.toDouble();
      } else if (firebaseData is double) {
        doubleValue = firebaseData;
      }
    }
    // double price = data['price'] as double;
    return ProductModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: doubleValue,
      imageUrl: data['imageUrl'] ?? '',
      // isFavorite: data['isFavorite'] ?? false,
      ownerId: data['ownerId'] ?? '',
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'isFavorite': isInMyCart,
      'ownerId': ownerId,
    };
  }

  // @override
  // String toString() {
  //   return 'ProductModel{name: $name, description: $description, price: $price, image: $imageUrl, isFavorite: $isInMyCart, id: $id, ownerId: $ownerId}';
  // }
}
