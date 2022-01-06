import 'dart:io';
import 'package:ateneo/globals.dart' as globals;
import 'package:ateneo/constants/theme_data.dart';
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
    globals.file = file;
    print('>' +file.toString());
    return Container(
      constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width/1.5,
          minHeight: 200
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: Gradientes.uno,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          image: imageFile != null
              ? DecorationImage(
              image: FileImage(file), fit: BoxFit.cover)
              : null),
      child: file.toString().length<20?IconButton(
        alignment: Alignment.center,
        icon: Icon(Icons.person),
        onPressed: () {
          _showPickerOpcions(context);
        },
        iconSize: 75,
        color: Theme
            .of(context)
            .secondaryHeaderColor,
      ):IconButton(
        alignment: Alignment.bottomRight,
        icon: Icon(Icons.photo),
        onPressed: () {
          _showPickerOpcions(context);
        },
        iconSize: 40,
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
          // ListTile(
          //   leading: Icon(Icons.camera_alt),
          //   title: Text("Camara"),
          //   onTap: () {
          //     Navigator.pop(context);
          //     _showPickImage(context, ImageSource.camera);
          //   },
          // ),
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
