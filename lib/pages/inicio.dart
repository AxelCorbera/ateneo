import 'dart:convert';
import 'package:ateneo/globals.dart' as globals;
import 'package:ateneo/constants/theme_data.dart';
import 'package:ateneo/provider/google_sing_in.dart';
import 'package:ateneo/scripts/objects/user.dart' as us;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

class Inicio extends StatefulWidget{
  Inicio({this.app});
  final FirebaseApp? app;
  _inicioState createState() => _inicioState();
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}


class _inicioState extends State<Inicio>{


  int _counter = 0;
  final referenceDatabase = FirebaseDatabase.instance;
  final publishController = TextEditingController();

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.getToken().then((token) {
      _token = token!;
      print("Device Token: $token");
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      print('inicial ?!');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription:
              channel.description,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: '@mipmap/ic_notification',
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final notification = message.notification;
      final data = message.data;
      String? body = notification!.body;
      String? title = notification.title;

      print('A new onMessageOpenedApp! $title $body $data');
    });

    //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //     print('A new onMessageOpenedApp event was published!');
    //     RemoteNotification? notification = message.notification;
    //     AndroidNotification? android = message.notification?.android;
    //     if (notification != null && android != null) {
    //       print('resume APP!');
    //       showDialog(
    //           context: context,
    //           builder: (_) {
    //             return AlertDialog(
    //               title: Text(notification.title.toString()),
    //               content: SingleChildScrollView(
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [Text(notification.body.toString())],
    //                 ),
    //               ),
    //             );
    //           });
    //     }
    //   });
  }

  void showNotification() {
    setState(() {
      _counter++;
    });
    flutterLocalNotificationsPlugin.show(
        0,
        "Testing $_counter",
        "How you doin ?",
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }

  String constructFCMPayload(String? token) {
    return jsonEncode({
      'token': token,
      'data': {
        'via': 'FlutterFire Cloud Messaging!!!',
        'count': 'TESTT',
      },
      'notification': {
        'title': 'Hello FlutterFire!',
        'body': 'This notification (#1) was created via FCM!',
      },
    });
  }
  String _token = '';

  Widget build(BuildContext context) {
    final FirebaseDatabase database = FirebaseDatabase(app: widget.app);
    DatabaseReference _publicaciones = database.reference().child('publications');
    final ref = referenceDatabase.reference();
    return Scaffold(
      backgroundColor: Colores.pageBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colores.menuBackgroundColor,
        actions: [IconButton(
          onPressed: (){
      logout();
      final provider = Provider.of<GoogleSignInProvider>(context,
          listen: false);
      provider.logout();

    Navigator.of(context).pushNamed('/Login');
          },
          icon: Icon(Icons.exit_to_app),
        ),
        ],
      ),
      drawer: Drawer(

      ),
      body: Row(
        children: <Widget>[
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 64,
                    minHeight: 64,
                    maxWidth: 64,
                    maxHeight: 64,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(globals.user.photoUrl.toString()),
                      fit: BoxFit.cover
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 7,),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white54,
                        ),
                        child: Form(
                            child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            height: 40,
                            child: TextFormField(
                              controller: publishController,
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(
                                ),
                                hintText: 'Escribe aqui...',
                                  focusedBorder:OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                        width: 0
                                    ),
                                  ),
                                  focusedErrorBorder:OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 0
                                    ),
                                  ),
                                  disabledBorder:OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 0
                                    ),
                                  ),
                                  enabledBorder:OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 0
                                    ),
                                  ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent,
                                    width: 0
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(onPressed: (){
                        // ref
                        //     .child('publicaciones')
                        //     .push()
                        //     .child('pub')
                        //     .set(publishController.text)
                        //     .asStream();
                        // publishController.clear();
                        sendPushMessage();
                      },
                        child: Text('Publicar'),),
                    )
                  ],
                ),
                Expanded(
                  child: FirebaseAnimatedList(query: _publicaciones,
                      itemBuilder: (BuildContext context,
                      DataSnapshot snapshot,
                      Animation<double> animation,
                          int index){
                        return InkWell(
                          onTap: () {},
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: GradientTemplate
                                    .gradientTemplate[1].colors,
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              // boxShadow: BoxShadow(
                              //   color: gradientColor.last.withOpacity(0.4),
                              //   blurRadius: 8,
                              //   spreadRadius: 2,
                              //   offset: Offset(4, 4),
                              // ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            constraints: const BoxConstraints(
                                              minWidth: 32,
                                              minHeight: 32,
                                              maxWidth: 32,
                                              maxHeight: 32,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[400],
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.person,
                                              size: 30,
                                              color: Theme.of(context).secondaryHeaderColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          '#user',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    IconButton(onPressed: (){
                                      _publicaciones.child(snapshot.key.toString())
                                          .remove();
                                    },
                                        icon: const Icon(Icons.delete))
                                  ],
                                ),
                                Text(
                                  snapshot.value['message'],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendPushMessage() async {
    if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {

      FirebaseFirestore.instance.collection('Messages').add({
        'message': publishController.text,
      })
          .then((value) => print("mensaje enviado"))
          .catchError((error) => print("Failed to add user: $error"));
      // await http.post(
      //   Uri.parse('https://api.rnfirebase.io/messaging/send'),
      //   headers: <String, String>{
      //     'Content-Type': 'application/json; charset=UTF-8',
      //   },
      //   body: constructFCMPayload(_token),
      // );
      // print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

  Future<Null> logout() async {
    FirebaseAuth.instance.signOut();
    globals.login = false;
    globals.user = us.User('', '', '', '', '', '', '', '','',[],[]);
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString('username', '');
    // prefs.setString('password', '');
    // prefs.setString('gId', '');
    // prefs.setString('gCorreo', '');
    // prefs.setString('gNombre', '');
    // prefs.setString('gDocumento', '');
    // prefs.setString('gTelefono', '');
    // prefs.setString('gPersona', '');
    // prefs.setString('gCuil', '');
    // prefs.setString('gRazonSocial', '');
    // prefs.setString('gToken', '');
    // prefs.setString('gIdCustomerMp', '');
    // prefs.setString('gIdCardMp', '');
    // prefs.setString('gProvincia', '');
    // prefs.setString('gMunicipio', '');
    // prefs.setString('gLocalidad', '');
    // prefs.setString('gCalle', '');
    // prefs.setString('gNumero', '');
    // prefs.setString('gPiso', '');
    // prefs.setString('gDepartamento', '');
    // prefs.setString('gFoto', '');
    // prefs.setBool('login', false);
    // globals.usuario = Usuario("", "", "", "", "", "", "", "", "", "", "", "",
    //     "", "", "", "", "", "", "", "");
  }
}