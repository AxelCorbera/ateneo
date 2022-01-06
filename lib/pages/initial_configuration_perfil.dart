import 'dart:io';

import 'package:ateneo/constants/theme_data.dart';
import 'package:ateneo/scripts/cloud_firestore.dart';
import 'package:ateneo/scripts/images_games.dart';
import 'package:ateneo/scripts/lista_rangos.dart';
import 'package:ateneo/scripts/objects/games.dart';
import 'package:ateneo/scripts/objects/games/dota2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ateneo/pages/components/firebase_storage_api.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ateneo/globals.dart' as globals;
import 'package:image_picker/image_picker.dart';

import 'components/imagePickerWidget.dart';

class Initial_Configuration_Perfil extends StatefulWidget {
  _Initial_Configuration_PerfilState createState() =>
      _Initial_Configuration_PerfilState();
}

class _Initial_Configuration_PerfilState
    extends State<Initial_Configuration_Perfil> {
  GlobalKey<FormState> _keyForm = GlobalKey();
  GlobalKey<ScaffoldState> _keyScaf = GlobalKey();
  XFile imageFile = new XFile('');
  String pais = '';
  List<String> paises = [
    'Argentina',
    'Bolivia',
    'Brasil',
    'Chile',
    'Colombia',
    'Ecuador',
    'Guayana',
    'Paraguay',
    'Peru',
    'Surinam',
    'Trinidad y Tobago',
    'Uruguay',
    'Venezuela',
    'Guayana Francesa'
  ];

  UploadTask? task;
  File? file;

  DateTime _selectedDate = DateTime(2000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _keyScaf,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: Gradientes.fondo)),
        child: Form(
          key: _keyForm,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    '¡Ultimo paso!',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
                Column(
                  children: _foto(),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        'Nacionalidad',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: DropdownButtonFormField(
                        dropdownColor: Colores.negro,
                        value: pais != '' ? pais : null,
                        onTap: () {},
                        onSaved: (value) {},
                        onChanged: (value) {
                          setState(() {
                            pais = value.toString();
                          });
                        },
                        hint: Text(
                          'Nacionalidad',
                          style: TextStyle(color: Colors.white),
                        ),
                        isExpanded: true,
                        items: paises.map((String val) {
                          return DropdownMenuItem(
                              value: val,
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    val,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ));
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        'Nacimiento',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    RaisedButton(
                      onPressed: () async {
                        _pickDateDialog();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      padding: const EdgeInsets.all(0.0),
                      child: Ink(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: Gradientes.uno),
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Container(
                          constraints: const BoxConstraints(
                              minWidth: 88.0, minHeight: 30.0),
                          // min sizes for Material buttons
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _selectedDate != DateTime(2000)
                                    ? _selectedDate.day.toString() +
                                        '/' +
                                        _selectedDate.month.toString() +
                                        '/' +
                                        _selectedDate.year.toString()
                                    : 'Seleccionar fecha',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                RaisedButton(
                  onPressed: pais != '' && _selectedDate != DateTime(2000)
                      ? () async {
                    _cargando(context);
                          globals.user.nationality = pais;
                          globals.user.birthday = _selectedDate.toString();
                          await uploadFile().then((value) => actualizarUser());
                        }
                      : null,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  padding: const EdgeInsets.all(0.0),
                  child: Ink(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: 40,
                    decoration: pais != '' && _selectedDate != DateTime(2000)
                        ? BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: Gradientes.dos),
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          )
                        : null,
                    child: Container(
                      constraints:
                          const BoxConstraints(minWidth: 88.0, minHeight: 30.0),
                      // min sizes for Material buttons
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '¡Comenzar!',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // task != null ? buildUploadStatus(task!) : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _foto() {
    return <Widget>[
      ImagePickerWidget(
        imageFile: imageFile,
        onImageSelected: (XFile file) {
          setState(() {
            imageFile = file;
          });
        },
      ),
    ];
  }

  void _pickDateDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime(1960),
            //what will be the previous supported year in picker
            lastDate: DateTime
                .now()) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        //for rebuilding the ui
        _selectedDate = pickedDate;
      });
    });
  }

  Future uploadFile() async {
    if (globals.file == null) return;

    final fileName = globals.file;
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, globals.file);
    setState(() {});

    if (task == null) return;
    try {
      final snapshot = await task!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();

      print('Download-Link: $urlDownload');

      globals.user.photoUrl = urlDownload;
    } catch (Exception) {
      print(Exception);
    }
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );

  void actualizarUser() async {
    Map<String, dynamic> map = Map();
    if (globals.user.photoUrl != '') map['photoUrl'] = globals.user.photoUrl;
    map['birthday'] = globals.user.birthday;
    map['games'] = globals.user.games;
    map['nationality'] = globals.user.nationality;

    await UpdateUser(globals.user.uid).updateUser(map).then((value) =>
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/Inicio', (Route<dynamic> route) => false));
  }

  void _cargando(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.transparent,
              content: Center(child: CircularProgressIndicator()));
        });
  }
}
