import 'dart:convert';
import 'package:ateneo/scripts/objects/user.dart' as us;
import 'package:ateneo/pages/inicio.dart';
import 'package:ateneo/pages/initial_configuration.dart';
import 'package:ateneo/pages/login.dart';
import 'package:ateneo/provider/google_sing_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ateneo/globals.dart' as globals;

class Home extends StatefulWidget {
  Home({this.app});
  final FirebaseApp? app;
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final firestoreInstance = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    print(globals.user.games);
    print(FirebaseAuth.instance.authStateChanges());
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshop) {
          if (snapshop.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshop.hasData) {
            cargarDatos();
            FirebaseAuth.instance.idTokenChanges();
            //instance.authStateChanges().listen((event) { cargarDatos();});
            if (globals.user.games != '') {
              print('hay juegos: ' + globals.user.games.toString());
              globals.login = true;
              return Inicio();
            } else {
              globals.login = true;
              return Initial_Configuration();
            }
          } else if (snapshop.hasError) {
            return Center(child: Text('Algo salio mal :('));
          } else {
            return Login();
          }
        },
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: ListTile(
                title: globals.login
                    ? Text('Cerrar sesion')
                    : Text('Iniciar sesion'),
                leading: globals.login
                    ? Icon(
                        Icons.exit_to_app,
                        color: Theme.of(context).primaryColor,
                      )
                    : Icon(
                        Icons.open_in_browser,
                        color: Theme.of(context).primaryColor,
                      ),
                onTap: () {
                  if (globals.login == true) {
                    //logout();
                    FirebaseAuth.instance.signOut();
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    provider.logout();
                    globals.login = false;
                    globals.user =
                        us.User('', '', '', '', '', '', '', '', '', [], []);
                  }
                  Navigator.of(context).pushNamed('/Login');
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void cargarDatos() {
    if (globals.user.uid == '') {
      firestoreInstance.collection("Users").get().then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          print(result.get('uid') + '<login>' + globals.userAuth!.uid);
          if (result.get('uid') == globals.userAuth!.uid) {
            print('cargar info > ' + result.get('uid'));
            globals.user.games = result.get('games');
            globals.user.uid = result.get('uid');
            globals.user.email = result.get('email');
            print('games cargados: ' + result.get('games'));
            globals.user.displayName = result.get('displayName');
            globals.user.birthday = result.get('birthday');
            globals.user.nationality = result.get('nationality');
            globals.user.photoUrl = result.get('photoUrl');
            globals.user.friendRequests =
            List<String>.from(result.get('friendRequests').map((x) => x));
            globals.user.friends =
            List<String>.from(result.get('friends').map((x) => x));
            globals.login = true;
            FirebaseAuth.instance.authStateChanges().listen((event) { print(event!.uid);});
          }
        });
      }).then((value) => cargarDatos());
    }else{
    }
  }
}
