import 'dart:convert';

import 'package:ateneo/constants/theme_data.dart';
import 'package:ateneo/provider/authentication_service.dart';
import 'package:ateneo/provider/google_sing_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
//import 'package:till/provider/authentication_service.dart';
// import 'package:till/scripts/db/json/tarjetas_firestore.dart';
// import 'package:till/scripts/request.dart' as request;
// import 'package:till/scripts/album.dart' as album;
// import 'package:till/scripts/request.dart' as request;
import 'package:ateneo/globals.dart' as globals;
// import 'package:till/scripts/request.dart';
// import 'package:till/constants/themes.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:till/provider/google_sing_in.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final firestoreInstance = FirebaseFirestore.instance;

  bool _loading = false;
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
              SizedBox(),
              Image.asset(
                'assets/logos/logovacio.png',
                height: 150,
              ),
              Center(
                  child: Text(
                    '#SLOGAN',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )),
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
                                  color: Colors.white,
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
                            decoration:
                            InputDecoration(labelText: "Clave",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                  style: BorderStyle.none,
                                ),
                              ),
                              //filled: true,
                              contentPadding: EdgeInsets.all(16),),
                            obscureText: true,
                            onSaved: (value) {
                              password = value!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Este campo es obligatorio';
                              }
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              FlatButton(onPressed: () {}, child: Text(
                                'Olvidé mi contraseña',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white
                                ),
                              ),),
                            ],
                          ),
                          RaisedButton(
                            onPressed: () {
                              _loading;
                              _login(context,true);
                              Navigator.of(context).pushNamed('/Home');
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            padding: const EdgeInsets.all(0.0),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                    colors:
                                    Gradientes.uno,
                                ),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10.0)),
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
                                      'Ingresar',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20
                                      ),
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
                          //if (_errorMessage.isNotEmpty)
                            // Padding(
                            //   padding: const EdgeInsets.all(18.0),
                            //   child: Text(
                            //     _errorMessage,
                            //     style: TextStyle(
                            //         color: Colores.rojo,
                            //         fontWeight: FontWeight.bold),
                            //     textAlign: TextAlign.center,
                            //   ),
                            // ),

                            //MENSAJE DE ERROR
                          SizedBox(
                            height: 10,
                          ),
                          FlatButton(
                            textColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            onPressed: () {
                              Navigator.of(context).pushNamed('/Register')
                              .then((context) => (){setState(() {
                              });});
                            },
                            child: Text("Crear cuenta",
                              style: TextStyle(
                                  color: Colors.white
                              ),),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RaisedButton(
                            onPressed: () {
                               _loginGoogle();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            padding: const EdgeInsets.all(0.0),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  colors: Gradientes.dos
                                ),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10.0)),
                              ),
                              child: Container(
                                constraints: const BoxConstraints(
                                    minWidth: 88.0, minHeight: 45.0),
                                // min sizes for Material buttons
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    FaIcon(FontAwesomeIcons.google,
                                      size: 25,
                                      color: Colors.white,),
                                    SizedBox(width: 10,),
                                    Text(
                                      'Iniciar con Google',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15
                                      ),
                                    ),
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
                              Navigator.of(context).pushNamed('/Home')
                                  .then((context) => (){setState(() {
                              });});
                            },
                            child: Text("Ingresar sin cuenta",
                              style: TextStyle(
                                  color: Colors.white
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
  //
  Future<void> _loginGoogle() async{
    var provider = await Provider.of<GoogleSignInProvider>(context, listen: false);
    provider.googleLogin().then((value) => {
    loginGoogle2(provider.user)
    });
  }
  //
  void loginGoogle2(GoogleSignInAccount user){
    print('inicio sesion google? id: ' + user.id);
    if(user.id.isNotEmpty) {
      var games = '';
      firestoreInstance.collection("Users").get().then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          print(result.get('uid') + '<google>' + user.id);
          if (result.get('uid') == user.id) {
            print('cargar info > ' + result.get('uid'));
            globals.user.uid = result.get('uid');
            globals.user.email = result.get('email');
            print('games cargados: ' + result.get('games'));
            globals.user.games = result.get('games');
            globals.user.displayName = result.get('displayName');
            globals.user.birthday = result.get('birthday');
            globals.user.nationality = result.get('nationality');
            globals.user.photoUrl = result.get('photoUrl');
            globals.user.friendRequests = result.get('friendRequests');
            globals.user.friends = result.get('friends');
            globals.login = true;
          }
        });
      });
          //.then((value) => _loginSave())
          //.then((value) => Ingreso(games));

      //Navigator.of(context).pushNamed('/Home');
      globals.login = true;
    }else{
      _mostrarMensaje('Error al iniciar sesion');
      globals.login = true;
    }
  }
  //
  void _login(BuildContext context, bool autolog) async {
    if (!_loading) {
      if (_keyForm.currentState!.validate()) {
        _keyForm.currentState!.save();
        setState(() {
          _loading = true;
        });

        final _auth = FirebaseAuth.instance;
        String log = await AuthenticationService(_auth)
            .signIn(email: userName, password: password);

          cargarDatos(_auth,log);
          }
        } else {
          setState(() {
            _loading = false;
            _errorMessage = "";
          });
    }
  }

  // void Ingreso(String games){
  //   if(games != '') {
  //     Navigator.of(context).pushNamed('/Home');
  //   }else{
  //     Navigator.of(context).pushNamed('/Initial_Configuration');
  //   }
  // }

  //
  // void _cargarInformacion(QuerySnapshot result, int i){
  //   globals.usuario!.id = result.docs[i].get('uid');
  //   globals.usuario!.correo = result.docs[i].get('correo');
  //   globals.usuario!.nombre = result.docs[i].get('nombre');
  //   globals.usuario!.documento = result.docs[i].get('documento');
  //   globals.usuario!.telefono = result.docs[i].get('telefono');
  //   globals.usuario!.persona = result.docs[i].get('persona');
  //   globals.usuario!.cuil = result.docs[i].get('cuil');
  //   globals.usuario!.razon_social = result.docs[i].get('razon_social');
  //   globals.usuario!.token = result.docs[i].get('token');
  //   globals.usuario!.id_customer_mp = result.docs[i].get('id_customer_mp');
  //   globals.usuario!.id_card_mp = result.docs[i].get('id_card_mp');
  //   globals.usuario!.provincia = result.docs[i].get('provincia');
  //   globals.usuario!.municipio = result.docs[i].get('municipio');
  //   globals.usuario!.localidad = result.docs[i].get('localidad');
  //   globals.usuario!.calle = result.docs[i].get('calle');
  //   globals.usuario!.numero = result.docs[i].get('numero');
  //   globals.usuario!.piso = result.docs[i].get('piso');
  //   globals.usuario!.departamento = result.docs[i].get('departamento');
  //   globals.usuario!.foto = result.docs[i].get('foto');
  // }
  //
  void _mostrarMensaje(String msg) {
    SnackBar snackBar = SnackBar(
      content: Text(msg),
    );
    _keyScaf.currentState!.showSnackBar(snackBar);
  }

  void cargarDatos(FirebaseAuth _auth, String log) {

    setState(() {
      if (log
          == 'Signed in') {
        _loading = false;
        _errorMessage = "";
        firestoreInstance.collection("Users").get().then((querySnapshot) {
          querySnapshot.docs.forEach((result) {
            print(result.get('uid') + '<login>' + _auth.currentUser!.uid);
            if (result.get('uid') == _auth.currentUser!.uid){
              print('cargar info > ' + result.get('uid'));
              globals.user.uid = result.get('uid');
              globals.user.email = result.get('email');
              print('games cargados: ' + result.get('games'));
              globals.user.games = result.get('games');
              globals.user.displayName = result.get('displayName');
              globals.user.birthday = result.get('birthday');
              globals.user.nationality = result.get('nationality');
              globals.user.photoUrl = result.get('photoUrl');
              globals.user.friendRequests = List<String>.from(result.get('friendRequests').map((x) => x));
              globals.user.friends = List<String>.from(result.get('friends').map((x) => x));
              globals.login = true;
            }
          });
        });

      } else if (log.contains('There is no user record corresponding')) {
        _loading = false;
        _errorMessage = "Usuario incorrecto";
        _mostrarMensaje('Usuario incorrecto');
      } else if (log.contains('The password is invalid')) {
        _loading = false;
        _errorMessage = "Clave incorrecta";
        _mostrarMensaje('Clave incorrecta');
      } else if (log.contains('Try again later')) {
        _loading = false;
        _errorMessage = "Has realizado muchos intentos. Intenta mas tarde";
        _mostrarMensaje('Has realizado muchos intentos. Intenta mas tarde');
      } else{
        _loading = false;
        _errorMessage = "Error de conexion";
        _mostrarMensaje(log);
      }
    });

  }

  //
  // // void initState() {
  // //   super.initState();
  // //   autoLogIn();
  // //   }
  //
  // void autoLogIn() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final String? userId = prefs.getString('username');
  //   final String? pass = prefs.getString('password');
  //
  //   if (userId != '' && userId != null) {
  //     userName = userId.toString();
  //     password = pass.toString();
  //     _login(context,true);
  //   }
  // }
  //
  // Future<Null> logout() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('username', '');
  //   prefs.setString('password', '');
  // }
  //
  // void _loginSave() async{
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('gId', globals.usuario!.id.toString());
  //   prefs.setString('gCorreo', globals.usuario!.correo.toString());
  //   prefs.setString('gNombre', globals.usuario!.nombre.toString());
  //   prefs.setString('gDocumento', globals.usuario!.documento.toString());
  //   prefs.setString('gTelefono', globals.usuario!.telefono.toString());
  //   prefs.setString('gPersona', globals.usuario!.persona.toString());
  //   prefs.setString('gCuil', globals.usuario!.cuil.toString());
  //   prefs.setString('gRazonSocial', globals.usuario!.razon_social.toString());
  //   prefs.setString('gToken', globals.usuario!.token.toString());
  //   prefs.setString('gIdCustomerMp', globals.usuario!.id_customer_mp.toString());
  //   prefs.setString('gIdCardMp', globals.usuario!.id_card_mp.toString());
  //   prefs.setString('gProvincia', globals.usuario!.provincia.toString());
  //   prefs.setString('gMunicipio', globals.usuario!.municipio.toString());
  //   prefs.setString('gLocalidad', globals.usuario!.localidad.toString());
  //   prefs.setString('gCalle', globals.usuario!.calle.toString());
  //   prefs.setString('gNumero', globals.usuario!.numero.toString());
  //   prefs.setString('gPiso', globals.usuario!.piso.toString());
  //   prefs.setString('gDepartamento', globals.usuario!.departamento.toString());
  //   prefs.setString('gFoto', globals.usuario!.foto.toString());
  //   prefs.setBool('login', true);
  // }
}
