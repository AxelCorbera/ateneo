import 'package:firebase_auth/firebase_auth.dart';
import 'package:ateneo/globals.dart' as globals;

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.idTokenChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> signIn({required String email,required String password}) async {
    try {
      print(email);
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)
      .then((value) => globals.userAuth = _firebaseAuth.currentUser );
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      print(e);
      return e.message.toString();
    }
  }

  Future<String> signUp({required String email,required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }
}