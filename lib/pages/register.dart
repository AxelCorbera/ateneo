import 'package:ateneo/constants/theme_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ateneo/provider/authentication_service.dart';
import 'package:ateneo/scripts/cloud_firestore.dart';
import 'package:ateneo/globals.dart' as globals;
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:ateneo/provider/google_sing_in.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final firestoreInstance = FirebaseFirestore.instance;
  bool _loading = false;
  String name = '';
  String userName = '';
  String password = '';
  String _errorMessage = "";
  GlobalKey<FormState> _keyForm = GlobalKey();
  GlobalKey<ScaffoldState> _keyScaf = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _keyScaf,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: Gradientes.fondo
          )
        ),
        child: Form(
          key: _keyForm,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Image.asset(
                    'assets/logos/logovacio.png',
                    height: 180,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                      child: Text(
                    '#SLOGAN',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Flexible(
                child: Container(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextFormField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "Usuario",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                  style: BorderStyle.none,
                                ),
                              ),
                              //filled: true,
                              contentPadding: EdgeInsets.all(16),
                            ),
                            onSaved: (value) {
                              name = value!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Este campo es obligatorio';
                              }
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "Correo electronico",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                  style: BorderStyle.none,
                                ),
                              ),
                              //filled: true,
                              contentPadding: EdgeInsets.all(16),
                            ),
                            onSaved: (value) {
                              userName = value!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Este campo es obligatorio';
                              }
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "Clave",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                  style: BorderStyle.none,
                                ),
                              ),
                              //filled: true,
                              contentPadding: EdgeInsets.all(16),
                            ),
                            obscureText: true,
                            onChanged: (value){
                              password = value;
                            },
                            onSaved: (value) {
                              password = value!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Este campo es obligatorio';
                              }
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "Repetir clave",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                  style: BorderStyle.none,
                                ),
                              ),
                              //filled: true,
                              contentPadding: EdgeInsets.all(16),
                            ),
                            obscureText: true,
                            validator: (value) {
                              print('$value + $password');
                              if (value! != password) {
                                return 'Las claves deben coincidir';
                              }
                              else if (value.isEmpty) {
                                return 'Este campo es obligatorio';
                              }
                            },
                          ),
                          SizedBox(height: 20,),
                          RaisedButton(
                            onPressed: () {
                              _loading;
                              _create();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            padding: const EdgeInsets.all(0.0),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    colors: Gradientes.uno),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Container(
                                constraints: const BoxConstraints(
                                    minWidth: 88.0, minHeight: 45.0),
                                // min sizes for Material buttons
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Crear cuenta',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    if (_loading)
                                      Container(
                                        height: 20,
                                        width: 20,
                                        margin: const EdgeInsets.only(left: 20),
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FlatButton(
                            textColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancelar",
                              style: TextStyle(
                                  color: Colores.cian
                              ),),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _create() async{
    if (!_loading) {
      if (_keyForm.currentState!.validate()) {
        _keyForm.currentState!.save();
        setState(() {
          _loading = true;
        });

        final _auth = FirebaseAuth.instance;
        String log = await AuthenticationService(_auth)
            .signUp(email: userName, password: password);

        bool existe = false;
        firestoreInstance.collection("users").get().then((querySnapshot) {
          querySnapshot.docs.forEach((result) {
            print(result.get('uid') + '<create>' + _auth.currentUser!.uid);
            if (result.get('uid') == _auth.currentUser!.uid) existe = true;
            print(existe);
          });
          if (existe == false) {
            final addU = AddUser(
                _auth.currentUser!.uid, name, userName, password);
            addU.addUser();
            print('usuario agregado');
          }
        });


        print(log);
        setState(() {
          if(log == "Signed up"){
            _mostrarMensaje('Se creo exitosamente!');
            Navigator.pop(context);
          }else if(log.contains('is already in use')){
            _mostrarMensaje('El correo ya esta en uso');
            _loading=false;
          }

        });

      }
    }
  }

  void _mostrarMensaje(String msg) {
    SnackBar snackBar = SnackBar(
      content: Text(msg),
    );
    _keyScaf.currentState!.showSnackBar(snackBar);
  }

  // void initState() {
  //   super.initState();
  //   autoLogIn();
  //   }
}
