import 'dart:io';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:store_room/models/product_storeroom.dart';
import 'package:store_room/models/store_room.dart';
import 'package:store_room/pages/store_page/subpages/room_details_page.dart';
import 'package:store_room/pages/store_page/views/circular_image_picker.dart';
import 'package:store_room/pages/search_page/views/scan_qr_code.dart';
import 'package:store_room/models/product.dart';
import 'package:store_room/services/database_helper_product.dart';
import 'package:store_room/services/database_helper_product_storeroom.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key, required this.storeRoom});

  final StoreRoom storeRoom;

  @override
  // ignore: library_private_types_in_public_api
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  //File? _image;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _buyingPriceController = TextEditingController();
  final TextEditingController _sellingPriceController = TextEditingController();

  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  final Logger logger = Logger(); // Assuming you have access to an instance

  File? productImage;
  bool isProductLoading = false;

  final List<String> list = <String>[
    'One',
    'Two',
    'Three',
    'Four'
  ]; // that will be fetched from the database later

  @override
  void initState() {
    isProductLoading = false;
    super.initState();
  }

  void _startQRScan() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScanQRCode()),
    );
    if (result != null) {
      setState(() {
        _codeController.text = result as String;
      });
    }
  }

  Future<String> saveImageToLocal() async {
    try {
      if (productImage == null) {
        throw ("There is no image to save");
      } else {
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String imagesDirPath = '${appDir.path}/images';

        // Check if the directory exists, if not create it
        if (!(await Directory(imagesDirPath).exists())) {
          await Directory(imagesDirPath).create(recursive: true);
        }

        final String imagePath =
            '$imagesDirPath/${_nameController.text.replaceAll(' ', '')}-${DateTime.now()}.jpg';

        final savedImagePath = (await productImage!.copy(imagePath)).path;
        return savedImagePath;
      }
    } catch (e) {
      print(e);
      return 'null';
    }
  }

  Future<void> _submit() async {
    try {
      if (_formKey.currentState!.validate()) {
        setState(() {
          isProductLoading = true;
        });

        String imagePath = await saveImageToLocal();

        final newProduct = Product(
          id: UniqueKey().toString(),
          title: _nameController.text,
          quantity: int.parse(_quantityController.text),
          buyingPrice: double.parse(_buyingPriceController.text),
          sellingPrice: double.parse(_sellingPriceController.text),
          category: _categoryController.text,
          code: _codeController.text,
          location: widget.storeRoom.title,
          imageUrl: imagePath,
        );

        // Insert the new product into the database
        await ProductDatabaseHelper.insertProduct(newProduct);

        final newProductStoreroom = ProductStoreroom(
          id: UniqueKey().toString(),
          productId: newProduct.id,
          storeroomId: widget.storeRoom.id,
        );

        await ProductStoreroomDatabaseHelper.insertProductStoreroom(
            newProductStoreroom);

        // Show a success message using SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ürün başarıyla eklendi.'),
            backgroundColor: Colors.green, // Set background color to green
          ),
        );

        // Clear input fields after successful submission
        _nameController.clear();
        _quantityController.clear();
        _buyingPriceController.clear();
        _sellingPriceController.clear();
        _categoryController.clear();
        _codeController.clear();
      }
    } catch (e) {
      // Handle any errors and log them
      logger.d('Error while submitting: $e');

      // Show an error message using SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ürün eklenirken bir hata oluştu.'),
          backgroundColor: Colors.red, // Set background color to red
        ),
      );
    }
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (ctx) => RoomDetailsPage(
                  storeRoom: widget.storeRoom,
                )));

    setState(() {
      isProductLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: !isProductLoading
          ? FloatingActionButton.extended(
              heroTag:
                  'addProduct_${widget.storeRoom.id}_${DateTime.now().millisecondsSinceEpoch}', // Unique heroTag
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _submit();
                }
              },
              icon: const Icon(Icons.upload_file_sharp),
              label: const Text('Ekle'),
              backgroundColor: const Color.fromARGB(
                  255, 238, 238, 240), // Set the background color
              foregroundColor: const Color.fromARGB(
                  255, 90, 6, 215), // Set the foreground color (text color)
              elevation: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      25), // Make the button more circular
                  side:
                      const BorderSide(color: Color.fromARGB(28, 61, 43, 43))),
            )
          : null,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Form(
          key: _formKey,
          child: !isProductLoading
              ? ListView(
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.009),
                    CircularImagePicker(
                      onImagePicked: (pickedImage) =>
                          {productImage = pickedImage},
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.004),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Ürün adı',
                        hintText: 'Ürün adını girin',
                        prefixIcon: const Icon(
                          Icons.data_object,
                          color: Color.fromARGB(255, 2, 5, 85),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen bir isim girin';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _quantityController,
                            decoration: InputDecoration(
                              labelText: 'Miktar',
                              hintText: 'Miktarı girin',
                              prefixIcon: const Icon(
                                Icons.production_quantity_limits,
                                color: Color.fromARGB(255, 243, 127, 4),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  int.parse(value) == 0) {
                                return 'Lütfen bir miktar girin';
                              }
                              return null;
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Color.fromARGB(
                                255, 166, 13, 2), // Color for the remove icon
                          ),
                          onPressed: () {
                            setState(() {
                              // Set quantity to 1 if it's empty or null
                              _quantityController.text =
                                  _quantityController.text.isEmpty
                                      ? '1'
                                      : _quantityController.text;

                              // Convert the quantity text to an integer
                              int quantity =
                                  int.parse(_quantityController.text);

                              // Decrease quantity only if it's greater than 0
                              if (quantity > 0) {
                                quantity--;
                                _quantityController.text = quantity.toString();
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: Color.fromARGB(
                                255, 4, 28, 162), // Color for the add icon
                          ),
                          onPressed: () {
                            setState(() {
                              _quantityController.text =
                                  _quantityController.text.isEmpty
                                      ? '0'
                                      : _quantityController.text;

                              int quantity =
                                  int.parse(_quantityController.text) + 1;
                              _quantityController.text = quantity.toString();
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _buyingPriceController,
                      decoration: InputDecoration(
                        labelText: 'Alış fiyatı',
                        hintText: 'Alış fiyatı girin',
                        prefixIcon: const Icon(
                          Icons.attach_money,
                          color: Color.fromARGB(255, 34, 75, 7),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen bir fiyat girin';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _sellingPriceController,
                      decoration: InputDecoration(
                        labelText: 'Satış fiyatı',
                        hintText: 'Satış fiyatı girin',
                        prefixIcon: const Icon(
                          Icons.attach_money,
                          color: Color.fromARGB(255, 34, 75, 7),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen bir fiyat girin';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _categoryController,
                            decoration: InputDecoration(
                              labelText: 'Kategori',
                              hintText: 'Kategori girin.',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: const Icon(
                                Icons.category,
                                color: Color.fromARGB(255, 209, 6, 6),
                              ),
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.arrow_drop_down),
                                    onSelected: (String? value) {
                                      setState(() {
                                        _categoryController.text = value!;
                                      });
                                    },
                                    itemBuilder: (BuildContext context) {
                                      return list.map((String category) {
                                        return PopupMenuItem<String>(
                                          value: category,
                                          child: Text(category),
                                        );
                                      }).toList();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Lütfen bir kategori belirtin';
                              }
                              return null;
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.info,
                            color: Color.fromARGB(139, 6, 8, 137),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Theme(
                                  data: ThemeData(
                                    // Customize the background color of the dialog
                                    dialogBackgroundColor: const Color.fromARGB(
                                        213, 255, 255, 255),
                                    // Customize the shadow of the dialog
                                    dialogTheme: DialogTheme(
                                      elevation:
                                          8.0, // Customize elevation (shadow)
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            36.0), // Customize border radius
                                      ),
                                    ),
                                  ),
                                  child: AlertDialog(
                                    title: const Text('İpucu'),
                                    content: const Text(
                                        'Kendiniz de yeni bir kategori ekleyebilir veya mevcut kategorilerden birini seçebilirsiniz'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Tamam'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            canRequestFocus: false,
                            controller: _codeController,
                            readOnly: true, // Make the field read-only
                            enableInteractiveSelection:
                                true, // Disable text selection
                            autofocus: true, // Disable autofocus
                            decoration: InputDecoration(
                              labelText: (_codeController.text.isNotEmpty)
                                  ? _codeController.text
                                  : 'Ürün kodu',
                              hintText: 'Ürün kodu',
                              prefixIcon: Container(
                                margin: const EdgeInsets.only(
                                    right: 8), // Add margin
                                child: const Icon(
                                  Icons.qr_code_2,
                                  color: Color.fromARGB(255, 34, 10, 166),
                                  size: 24, // Set the size of the icon
                                  shadows: [Shadow(color: Colors.black)],
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value == '') {
                                return 'Lütfen bir kod girin';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _startQRScan();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor:
                                const Color.fromARGB(255, 2, 41, 236),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal:
                                    16), // Adjust padding for smaller button
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.find_in_page),
                              SizedBox(width: 8),
                              Text(
                                'Tara',
                                style: TextStyle(
                                    fontSize:
                                        14), // Decrease font size for smaller button
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
