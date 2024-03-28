import 'package:flutter/material.dart';
import 'package:store_room2/models/product.dart'; // Import the Product class
import 'package:store_room2/pages/store_page/subpages/add_product_page.dart';
import 'package:store_room2/pages/store_page/views/product_list_item.dart'; // Import the ProductListItem widget

class RoomDetailsPage extends StatefulWidget {
  const RoomDetailsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RoomDetailsPageState createState() => _RoomDetailsPageState();
}

class _RoomDetailsPageState extends State<RoomDetailsPage> {
  // List of items (dummy Product objects)
  List<Product> products = [
    const Product(
      id: 1,
      roomId: 'room_id_1',
      title: 'Product 1',
      quantity: 5,
      price: 10.99,
      category: 'Category 1',
      code: 'P001',
      space: 'Space 1',
      location: 'Location 1',
      imageUrl: 'https://example.com/image1.jpg',
    ),
    const Product(
      id: 2,
      roomId: 'room_id_2',
      title: 'Product 2',
      quantity: 10,
      price: 19.99,
      category: 'Category 2',
      code: 'P002',
      space: 'Space 2',
      location: 'Location 2',
      imageUrl: 'https://example.com/image2.jpg',
    ),
    // Add more dummy products as needed
  ];

  // Filtered items based on search query
  List<Product> filteredProducts = [];

  // Search query string
  String searchQuery = '';

  // Function to filter items based on search query
  void filterProducts(String query) {
    setState(
      () {
        if (query.isEmpty) {
          filteredProducts = [...products];
        } else {
          filteredProducts = products
              .where((product) => product.title.toLowerCase().contains(
                    query.toLowerCase(),
                  ))
              .toList();
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    filteredProducts = [...products];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alan detayları'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Implement filter by category functionality
              // You can show a dialog with categories or navigate to another page
              // where users can select categories to filter
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement add new product functionality
          // You can show a dialog or navigate to another page to add a new product

          Navigator.push(
              context, MaterialPageRoute(builder: (ctx) => AddProductPage()));
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(36.0),
                ),
              ),
              onChanged: (value) {
                filterProducts(value);
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  return ProductListItem(
                    product: filteredProducts[
                        index], // Pass the Product object to ProductListItem
                    // Implement delete functionality when the item is swiped
                    onDismissed: () {
                      setState(() {
                        filteredProducts.removeAt(index);
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
