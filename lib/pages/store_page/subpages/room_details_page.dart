import 'package:flutter/material.dart';
import 'package:store_room/models/product.dart'; // Import the Product class
import 'package:store_room/models/store_room.dart';
import 'package:store_room/pages/store_page/subpages/add_product_page.dart';
import 'package:store_room/pages/store_page/views/product_list_item.dart';
import 'package:store_room/services/database_helper_product.dart';
import 'package:store_room/services/database_helper_product_storeroom.dart'; // Import the ProductListItem widget

class RoomDetailsPage extends StatefulWidget {
  RoomDetailsPage({super.key, required this.storeRoom});

  final StoreRoom storeRoom;

  @override
  // ignore: library_private_types_in_public_api
  _RoomDetailsPageState createState() => _RoomDetailsPageState();
}

class _RoomDetailsPageState extends State<RoomDetailsPage> {
  List<Product> storeProducts = [];
  List<Product> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    initializeProducts();
  }

  void initializeProducts() async {
    storeProducts = await fetchStoreProducts();
    filteredProducts = List.from(storeProducts);
    setState(() {});
  }

  Future<List<Product>> fetchStoreProducts() async {
    List<String> productIds =
        await ProductStoreroomDatabaseHelper.getProductIdsByStoreroomId(
            widget.storeRoom.id);
    return await ProductDatabaseHelper.getProductsByIds(productIds);
  }

  // Filtered items based on search query

  // Search query string
  String searchQuery = '';

  // Function to filter items based on search query
  void filterProducts(String query) {
    setState(
      () {
        if (query.isEmpty) {
          filteredProducts = [...storeProducts];
        } else {
          filteredProducts = storeProducts
              .where((product) => product.title.toLowerCase().contains(
                    query.toLowerCase(),
                  ))
              .toList();
        }
      },
    );
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
        heroTag: 'addProductFromDetails',
        onPressed: () {
          // Implement add new product functionality
          // You can show a dialog or navigate to another page to add a new product

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (ctx) => AddProductPage(
                        storeRoom: widget.storeRoom,
                      )));
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
                        filteredProducts.removeAt(
                            index); // call database remove products with both products and productStoreRoom
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
