import 'package:flutter/material.dart';
import 'package:store_room2/models/product.dart'; // Import the Product class

class ProductListItem extends StatelessWidget {
  final Product product; // Product object
  final Function()? onDismissed; // Function to be called when item is dismissed

  const ProductListItem({
    required this.product, // Require Product object
    this.onDismissed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(product.id.toString()), // Unique key for Dismissible
      onDismissed: (direction) {
        if (onDismissed != null) {
          onDismissed!(); // Call onDismissed function if provided
        }
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16.0),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(product.imageUrl),
        ),
        title: Text(product.title),
        subtitle: Text('Quantity: ${product.quantity}, Price: \$${product.price.toStringAsFixed(2)}'),
      ),
    );
  }
}
