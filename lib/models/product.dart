class Product {
  final int id;
  final String roomId;
  final String title;
  final int quantity;
  final double price;
  final String category;
  final String code;
  final String space;
  final String location;
  final String imageUrl;

  const Product({
    required this.id,
    required this.roomId,
    required this.title,
    required this.quantity,
    required this.price,
    required this.category,
    required this.code,
    required this.space,
    required this.location,
    required this.imageUrl,
  });

  // Deserialize JSON to Product object
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      roomId: json['roomId'],
      title: json['title'],
      quantity: json['quantity'],
      price: json['price'],
      category: json['category'],
      code: json['code'],
      space: json['space'],
      location: json['location'],
      imageUrl: json['imageUrl'],
    );
  }

  // Serialize Product object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'title': title,
      'quantity': quantity,
      'price': price,
      'category': category,
      'code': code,
      'space': space,
      'location': location,
      'imageUrl': imageUrl,
    };
  }
}
