import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:qaabl_mobile/services/auth_service.dart';
// import 'package:qaabl_mobile/services/firestore_service.dart';
// import 'package:qaabl_mobile/app/app.locator.dart';

class MessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // final _authenticationService = locator<AuthenticationService>();
  // final _firestoreService = locator<FirestoreService>();

  Future initialize() async {
    final settings = await _firebaseMessaging.getNotificationSettings();
    // Request permission if on iOS
    if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
      // If permissions have not been determined, request permission
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle the notification caused by a foreground FCM push
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    // Handle background and terminated messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // Navigate to the desired screen based on the message
    });

    // Register the background message handler
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

    // _firebaseMessaging.onTokenRefresh.listen((newToken) {
    //   // Update the token on the server
    //   set_token();
    // });
  }

  Future<String?> get_token() async {
    try {
      final token = await _firebaseMessaging.getToken();
      return token;
    } catch (error) {
      print("Failed to generate token: " + error.toString());
      return "no token";
    }
  }
}

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}
