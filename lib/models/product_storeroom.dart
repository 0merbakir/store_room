class ProductStoreroom {
  final String id;
  final String productId;
  final String storeroomId;

  ProductStoreroom({
    required this.id,
    required this.productId,
    required this.storeroomId,
  });

  // Factory constructor to create a ProductStoreroom object from a map
  factory ProductStoreroom.fromMap(Map<String, dynamic> map) {
    return ProductStoreroom(
      id: map['id'],
      productId: map['productId'],
      storeroomId: map['storeroomId'],
    );
  }

  // Method to convert a ProductStoreroom object to a map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'storeroomId': storeroomId,
    };
  }
}
