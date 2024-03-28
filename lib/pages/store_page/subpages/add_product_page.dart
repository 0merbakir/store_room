import 'package:flutter/material.dart';
import 'package:store_room2/pages/store_page/views/circular_image_picker.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  //File? _image;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _spaceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Form verilerini gönder
            // Burada ürünü veritabanınıza kaydedebilirsiniz
            // ve önceki ekrana geri dönebilirsiniz
          }
        },
        icon: const Icon(Icons.save),
        label: const Text('Kaydet'),
        backgroundColor: const Color.fromARGB(214, 238, 238, 240), // Set the background color
        foregroundColor: const Color.fromARGB(200, 5, 5, 168), // Set the foreground color (text color)
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(25), // Make the button more circular
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CircularImagePicker(onPickImage: (image) {
                setState(() {
                  // refresh page
                });
              }),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Ürün Adı',
                  hintText: 'Ürün adını girin',
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
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'Miktar',
                  hintText: 'Miktarı girin',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir miktar girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Fiyat',
                  hintText: 'Fiyatı girin',
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
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  hintText: 'Kategoriyi girin',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.filter_alt),
                    onPressed: () {
                      // Kategori filtreleme işlevselliğini uygulayın
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir kategori girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _codeController,
                      readOnly:
                          true, // Klavye girişini engellemek için pasif hale getirin
                      decoration: InputDecoration(
                        labelText: 'Kod',
                        hintText: 'Kodu tarayın',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen bir kod girin';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.qr_code),
                    onPressed: () {
                      // QR kod tarayıcı işlevi eklenecek
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _spaceController,
                decoration: InputDecoration(
                  labelText: 'Alan',
                  hintText: 'Hacim (cm³)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir alan girin';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
