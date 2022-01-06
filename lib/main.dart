import 'dart:async';
import 'dart:convert';

import 'package:ateneo/pages/home.dart';
import 'package:ateneo/pages/initial_configuration.dart';
import 'package:ateneo/pages/initial_configuration_perfil.dart';
import 'package:ateneo/pages/register.dart';
import 'package:ateneo/provider/google_sing_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'constants/theme_data.dart';
import 'pages/login.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBvHFOfh-SE2SBLVW5jDYd0hnXul6sO36c',
      appId: '1:426559626478:android:f5e0081a180c346d8967ff',
      messagingSenderId: '448618578101',
      projectId: 'ateneo-ce866',
    ),
  );

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
  create: (context) => GoogleSignInProvider(),
  child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.white,
          hoverColor: Colors.white,
          focusColor: Colors.white,
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colores.cian, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.white, width: 1),
          ),
        ),
      ),
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (BuildContext context) {
          switch (settings.name) {
            case "/Home":
              return Home();
            case "/Login":
              return Login();
            case "/Register":
              return Register();
            case "/Initial_Configuration":
              return Initial_Configuration();
            case "/Initial_Configuration_Perfil":
              return Initial_Configuration_Perfil();
            default:
              return Home();
          }
        });
      },
    )
  );
}
