import 'package:ateneo/constants/theme_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Home extends StatefulWidget {
  Home({this.app});
  final FirebaseApp? app;
  _HomeState createState() => _HomeState();
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

class _HomeState extends State<Home> {
  int _counter = 0;
  final referenceDatabase = FirebaseDatabase.instance;
  final publishController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title.toString()),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body.toString())],
                  ),
                ),
              );
            });
      }
    });
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


  @override
  Widget build(BuildContext context) {
    main();
    final FirebaseDatabase database = FirebaseDatabase(app: widget.app);
    DatabaseReference _publicaciones = database.reference().child('publicaciones');
    final ref = referenceDatabase.reference();
    return Scaffold(
      backgroundColor: CustomColors.pageBackgroundColor,
      appBar: AppBar(
        backgroundColor: CustomColors.menuBackgroundColor,
      ),
      drawer: Drawer(),
      body: Row(
        children: <Widget>[
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  constraints: BoxConstraints(
                    minWidth: 64,
                    minHeight: 64,
                    maxWidth: 64,
                    maxHeight: 64,
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
                          color: CustomColors.minHandStatColor,
                        ),
                        child: Form(
                            child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            controller: publishController,
                          ),
                        )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(onPressed: (){
                        ref
                            .child('publicaciones')
                            .push()
                            .child('pub')
                            .set(publishController.text)
                            .asStream();
                        publishController.clear();
                      },
                        child: Text('Publicar'),),
                    )
                  ],
                ),
                Expanded(
                  child: new FirebaseAnimatedList(query: _publicaciones,
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
                                            constraints: BoxConstraints(
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
                                        SizedBox(width: 8),
                                        Text(
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
                                        icon: Icon(Icons.delete))
                                  ],
                                ),
                                Text(
                                  snapshot.value['pub'],
                                  style: TextStyle(
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
}
