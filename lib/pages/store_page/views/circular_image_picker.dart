import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CircularImagePicker extends StatefulWidget {
    final Function(File) onImagePicked;
   CircularImagePicker({super.key, required this.onImagePicked});

  @override
  // ignore: library_private_types_in_public_api
  _CircularImagePickerState createState() => _CircularImagePickerState();
}

class _CircularImagePickerState extends State<CircularImagePicker> {
  File? _pickedImageFile;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(
      source: source,
      maxWidth: 150,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
      widget.onImagePicked(_pickedImageFile!);
    });
  }

  void _showImageSourceOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Fotoğraf Çek'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image_search),
              title: const Text('Galeriden Seç'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                _showImageSourceOptions(context);
              },
              child: _pickedImageFile != null
                  ? CircleAvatar(
                      radius: 75,
                      backgroundColor: Colors.grey,
                      foregroundImage: FileImage(_pickedImageFile!),
                    )
                  : const CircleAvatar(
                      radius: 75,
                      backgroundColor: Colors.transparent,
                      foregroundImage: AssetImage('assets/images/dragon.png'),
                    ),
            ),
            if (_pickedImageFile == null)
              GestureDetector(
                onTap: () {
                  _showImageSourceOptions(context);
                },
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _showImageSourceOptions(context);
                      },
                      icon: const Icon(
                        Icons.add_a_photo,
                        color:  Color.fromARGB(111, 4, 5, 81), // Set the color of the icon
                        size: 30, // Set the size of the icon
                      ),
                    ),
                    const Text(
                      'Görsel ekle',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(211, 4, 5, 81)), // Adjust the font size and color as needed
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
