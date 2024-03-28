import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CircularImagePicker extends StatefulWidget {
  const CircularImagePicker({
    super.key,
    required this.onPickImage,
  });

  final void Function(File pickedImage) onPickImage;

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
    });

    widget.onPickImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 45,
          backgroundColor: Colors.grey,
          foregroundImage:
              _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
        ),
        const SizedBox(height: 10),
        Row(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(foregroundColor: Colors.white),
              onPressed: () => _pickImage(ImageSource.camera),
              icon: const Icon(
                Icons.camera,
                color: Colors.black,
              ),
              label: const Text('Kamera', style: TextStyle(color: Colors.black),),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(foregroundColor: Colors.white),
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: const Icon(
                Icons.image,
                color: Colors.black,
              ),
              label: const Text('Galeri', style: TextStyle(color: Colors.black),),
            ),
          ],
        ),
      ],
    );
  }
}
