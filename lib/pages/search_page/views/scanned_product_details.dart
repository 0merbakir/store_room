import 'dart:io';

import 'package:flutter/material.dart';
import 'package:store_room/main.dart';
import 'package:store_room/models/product.dart';
import 'package:store_room/services/database_helper_product.dart';

class ScannedProductDetails extends StatefulWidget {
  final String code;

  const ScannedProductDetails({Key? key, required this.code}) : super(key: key);

  @override
  State<ScannedProductDetails> createState() => _ScannedProductDetailsState();
}

class _ScannedProductDetailsState extends State<ScannedProductDetails> {
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    initializeProducts();
  }

  void initializeProducts() async {
    _products = await fetchProducts();
    setState(() {});
  }

  Future<List<Product>> fetchProducts() async {
    return await ProductDatabaseHelper.getProductsByCode(widget.code);
  }

  Future<File?> getLocalImageFile(String imagePath) async {
    print('Image Path: $imagePath');
    try {
      return File(imagePath);
    } catch (e) {
      print('Error fetching local image file: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (BuildContext context, ScrollController scrollController) {
        return Material(
          elevation: 8,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (ctx) => BottomBar()));
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _products.isEmpty
                    ? const Center(
                        child: Text(
                          'Ürün Bulunamadı!',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                        controller: scrollController,
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          Product product = _products[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Card(
                              elevation: 4,
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                constraints: const BoxConstraints(
                                  minHeight: 150,
                                ),
                                child: ListTile(
                                  title: Text(
                                    product.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildDetailRow(
                                          'Kategori', product.category),
                                      _buildDetailRow('Alış Fiyatı',
                                          '${product.buyingPrice}'),
                                      _buildDetailRow('Stış Fiyatı',
                                          '${product.sellingPrice}'),
                                      _buildDetailRow(
                                          'Miktar', '${product.quantity}'),
                                      _buildDetailRow(
                                          'Konum', product.location),
                                    ],
                                  ),
                                  leading: SizedBox(
                                    width: 70,
                                    height: 70,
                                    child: FutureBuilder<File?>(
                                      future: product.imageUrl != "null"
                                          ? getLocalImageFile(product.imageUrl)
                                          : null,
                                      builder: (context, snapshot) {
                                        if (product.imageUrl != "null" &&
                                            snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (product.imageUrl != "null" &&
                                            snapshot.hasError) {
                                          return const Icon(Icons.error);
                                        } else if (product.imageUrl != "null" &&
                                            snapshot.hasData &&
                                            snapshot.data != null) {
                                          return CircleAvatar(
                                            backgroundImage:
                                                FileImage(snapshot.data!),
                                            radius:
                                                0, // Adjust the radius as needed
                                          );
                                        } else {
                                          return const Icon(Icons.image);
                                        }
                                      },
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.ads_click),
                                    onPressed: () {
                                      // depoya gitme özelliği eklenecek
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 1, // Set the maximum number of lines
              overflow: TextOverflow
                  .ellipsis, // Truncate overflowed text with ellipsis
            ),
          ),
        ],
      ),
    );
  }
}
