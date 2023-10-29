import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

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

  Future<bool> signInWithApple() async {
    try {
      print("HERE");
      final rawNonce = createNonce(32);
      print("DONE1");
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: sha256.convert(utf8.encode(rawNonce)).toString(),
      );
      print("DONE2");
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );
      print("DONE3");
      await _firebaseAuth.signInWithCredential(oauthCredential);
      return true;
    } catch (error) {
      // Optionally, handle or print the error here
      print('Error signing in with Apple: $error');
      return false;
    }
  }

  String createNonce(int length) {
    final random = Random();
    final charSet =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    final nonce = List.generate(
        length, (index) => charSet[random.nextInt(charSet.length)]);
    return nonce.join();
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
