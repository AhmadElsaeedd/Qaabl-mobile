import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

class MessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future initialize() async {
    // Request permission if on iOS
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle the incoming notification here
    });

    // Handle background and terminated messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle the notification caused by tapping on it
    });

    // Register the background message handler
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  }

  Future<String?> get_token() async{
    try{
      final token = await _firebaseMessaging.getToken();
      return token;
    }
    catch (error){
      print("Failed to generate token: " + error.toString());
      return "no token";
    }
    
  }
}

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}
