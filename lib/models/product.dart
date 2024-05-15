class Product {
  final String id;
  final String title;
  final int quantity;  // çıkarılacak
  final double buyingPrice;
  final double sellingPrice;
  final String category;
  final String code;
  final String location;
  final String imageUrl;

  const Product({
    required this.id,
    required this.title,
    required this.quantity,
    required this.buyingPrice,
    required this.sellingPrice,
    required this.category,
    required this.code,
    required this.location,
    required this.imageUrl,
  });

  // Deserialize JSON to Product object
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      quantity: json['quantity'],
      buyingPrice: json['buyingPrice'],
      sellingPrice: json['buyingPrice'],
      category: json['category'],
      code: json['code'],
      location: json['location'],
      imageUrl: json['imageUrl'],
    );
  }

  // Serialize Product object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'quantity': quantity,
      'buyingPrice': buyingPrice,
      'sellingPrice': sellingPrice,
      'category': category,
      'code': code,
      'location': location,
      'imageUrl': imageUrl,
    };
  }
}
