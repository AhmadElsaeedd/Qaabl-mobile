import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:google_sign_in/google_sign_in.dart';

@lazySingleton
class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthenticationService() {
    _firebaseAuth.useAuthEmulator('localhost', 9104);
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      print("Button clicked");
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        await _firebaseAuth.signInWithCredential(credential);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  void edit_password_email() async {
    //get the email of the user
    try {
      String? email = _firebaseAuth.currentUser!.email as String;
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (error) {
      print("Failed to send email: " + error.toString());
    }
  }
}
