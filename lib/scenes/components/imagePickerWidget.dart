import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

typedef OnImageSelected = Function(XFile imageFile);

class ImagePickerWidget extends StatelessWidget {
  final XFile imageFile;
  final OnImageSelected onImageSelected;
  ImagePickerWidget({required this.imageFile, required this.onImageSelected});
  File file = File('');
  @override
  Widget build(BuildContext context) {
    file = File(imageFile.path);
    return Container(
      constraints: BoxConstraints(
          minWidth: double.infinity,
          minHeight: 250
      ),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey[300] as Color,
              Colors.grey[600] as Color,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          image: imageFile != null
              ? DecorationImage(
              image: FileImage(file), fit: BoxFit.cover)
              : null),
      child: IconButton(
        alignment: Alignment.bottomRight,
        icon: Icon(Icons.camera_alt),
        onPressed: () {
          _showPickerOpcions(context);
        },
        iconSize: 75,
        color: Theme
            .of(context)
            .secondaryHeaderColor,
      ),
    );
  }
  void _showPickerOpcions(BuildContext context) {
    showDialog(context: context, builder: (BuildContext context) {
      return SimpleDialog(
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text("Camara"),
            onTap: () {
              Navigator.pop(context);
              _showPickImage(context, ImageSource.camera);
            },
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text("Galeria"),
            onTap: () {
              Navigator.pop(context);
              _showPickImage(context, ImageSource.gallery);
            },
          )
        ],
      );
    });
  }

  void _showPickImage(BuildContext context, source) async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: source);
    if(image!=null)
    this.onImageSelected(image);
  }
}
