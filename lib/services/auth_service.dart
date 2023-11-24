import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:qaabl_mobile/app/app.locator.dart';
import 'package:qaabl_mobile/services/mixpanel_service.dart';

@lazySingleton
class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _mixpanelService = locator<MixpanelService>();

  AuthenticationService() {
    _firebaseAuth.useAuthEmulator('localhost', 9106);
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
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

  Future<Map<String, dynamic>?> signInWithGoogle() async {
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
        UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        // Check if the user is new or existing
        bool isNewUser = userCredential.additionalUserInfo!.isNewUser;
        // Return the email after a successful sign-in
        return {
          'email': googleSignInAccount.email,
          'isNewUser': isNewUser,
        };
      }
      return null;
    } catch (e) {
      // Optionally, handle or print the error here
      print('Error signing in with Google: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> signInWithApple() async {
    try {
      final rawNonce = createNonce(32);
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: sha256.convert(utf8.encode(rawNonce)).toString(),
      );
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(oauthCredential);
      // Check if the user is new or existing
      bool isNewUser = userCredential.additionalUserInfo!.isNewUser;
      return {
        'email': appleCredential.email,
        'isNewUser': isNewUser,
      };
    } catch (error) {
      // Optionally, handle or print the error here
      print('Error signing in with Apple: $error');
      return null;
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
      _mixpanelService.mixpanel.track("Changed Password");
    } catch (error) {
      print("Failed to send email: " + error.toString());
    }
  }
}
