import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ateneo/globals.dart' as globals;

class AddUser {
  final String uid;
  final String nombre;
  final String correo;
  final String token;

  AddUser(this.uid, this.nombre, this.correo, this.token);

  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  Future<void> addUser() async {
    // Call the user's CollectionReference to add a new user
    users
        .add({
          'uid': uid,
          'displayName': nombre,
          'email': correo,
          'photoUrl': '',
          'id': '',
          'birthday': '',
          'games': '',
          'user': '',
          'nationality': '',
          'friends': '[]',
          'friendRequests': '[]',
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}

class UpdateUser {
  final String uid;
  String? displayUser;
  String? email;
  String? id;
  String? photoUrl;
  String? birthday;
  String? games;
  String? user;
  String? nationality;
  List<String>? friends;
  List<String>? friendRequests;

  UpdateUser(this.uid,
      {this.displayUser,
      this.email,
      this.id,
      this.photoUrl,
      this.birthday,
      this.user,
      this.games,
      this.nationality,
      this.friends,
      this.friendRequests});

  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  Future<String> docID() async {
    String did = '';
    await FirebaseFirestore.instance
        .collection('Users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc['uid']);
        if (doc['uid'] == uid) {
          did = doc.id;
        }
      });
    });
    print('doc > $did');
    return did;
  }

  Future<void> updateUser(Map<String, dynamic> datos) async {
    String docId = await docID();
    return users
        .doc(docId)
        .update(datos)
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
}
