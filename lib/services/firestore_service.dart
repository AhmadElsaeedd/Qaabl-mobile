import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_app/models/match_model.dart';
import 'package:stacked_app/models/message_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:stacked_app/app/app.locator.dart';
import 'package:stacked_app/services/messaging_service.dart';


@lazySingleton
class FirestoreService {
  final _messagingService = locator<MessagingService>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // FirestoreService(){
  //   _firestore.settings = const Settings(
  //     host: 'localhost:8084',
  //     sslEnabled: true,
  //     persistenceEnabled: false,
  //   );
  //   print("Firestore settings: " + _firestore.settings.toString());
  // }

  FirestoreService() {
    _firestore.useFirestoreEmulator('localhost', 8085);
    print("I am using the emulator: " + _firestore.settings.toString());
  }

  Stream<List<ChatMatch>> get_old_matches(String uid) {
    print("user making request is: " + uid.toString());
    return _firestore
        .collection('Matches')
        .where('users', arrayContains: uid)
        .where('has_message', isEqualTo: true)
        .orderBy('timestamp', descending: true)
        .limit(5)
        .snapshots()
        .asyncMap((snapshot) async {
      print("asyncMap start, snapshot.docs.length: ${snapshot.docs.length}");
      print(
          "Snapshot metadata, isFromCache: ${snapshot.metadata.isFromCache}, hasPendingWrites: ${snapshot.metadata.hasPendingWrites}");

      if (snapshot.docs.isEmpty) {
        print("No documents found in snapshot");
      } else {
        print(
            "Documents found: ${snapshot.docs.map((doc) => doc.id).join(', ')}");
      }
      //getting the name of the other user
      //using futures to fetch in parallel
      final futures = <Future<ChatMatch>>[];
      for (final doc in snapshot.docs) {
        final match = ChatMatch.fromDocument(doc, uid);
        final otherUserId = match.other_user_id;
        final future = get_user_info(otherUserId).then((userInfo) {
          match.other_user_name =
              userInfo['name']; // Ensure this is a mutable property
          match.other_user_pic = userInfo['image_index'];
          return match;
        });
        futures.add(future);
      }
      final matches = await Future.wait(futures);
      print("asyncMap end, matches.length: ${matches.length}");
      return matches;
    }).handleError((error) {
      print("Error fetching old matches: $error");
    });
  }

  //ignore: non_constant_identifier_names
  Stream<List<ChatMatch>> get_new_matches(String uid) {
    print("get new matches start");
    //query to return the new chats
    return _firestore
        .collection('Matches')
        .where('users', arrayContains: uid)
        .where('has_message', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        .limit(5)
        .snapshots()
        .asyncMap((snapshot) async {
      print("asyncMap start, snapshot.docs.length: ${snapshot.docs.length}");
      print(
          "Snapshot metadata, isFromCache: ${snapshot.metadata.isFromCache}, hasPendingWrites: ${snapshot.metadata.hasPendingWrites}");

      if (snapshot.docs.isEmpty) {
        print("No documents found in snapshot");
      } else {
        print(
            "Documents found: ${snapshot.docs.map((doc) => doc.id).join(', ')}");
      }
      //getting the name of the other user
      //using futures to fetch in parallel
      final futures = <Future<ChatMatch>>[];
      for (final doc in snapshot.docs) {
        final match = ChatMatch.fromDocument(doc, uid);
        final otherUserId =
            match.other_user_id; // Ensure this is the correct property name
        final future = get_user_info(otherUserId).then((userInfo) {
          match.other_user_name =
              userInfo['name']; // Ensure this is a mutable property
          match.other_user_pic = userInfo['image_index'];
          return match;
        });
        futures.add(future);
      }
      final matches = await Future.wait(futures);
      print("asyncMap end, matches.length: ${matches.length}");
      return matches;
    }).handleError((error) {
      print("Error fetching new matches: $error");
    });
  }

  // ignore: non_constant_identifier_names
  Future<Map<String, dynamic>> get_user_info(String uid) async {
    try {
      final doc = await _firestore.collection('Users').doc(uid).get();
      final data = doc.data() as Map<String, dynamic>;
      String name = data['name'] ?? 'No Name';
      int imageIndex = data['image_index'];
      print("IMAGE INDEX IS: " + imageIndex.toString());
      return {'name': name, 'image_index': imageIndex};
    } catch (e) {
      print('Error fetching user info: $e');
      return {'name': 'No Name', 'imageIndex': 0};
    }
  }

  //function to add a message to the chat
  Future<void> send_message(String chat_id, String content, String uid) async {
    //final response =
    await http.post(
      //production url
      //Uri.parse('https://asia-east2-qaabl-mobile-dev.cloudfunctions.net/AddMessage'),
      //testing url
      Uri.parse('http://127.0.0.1:5003/qaabl-mobile-dev/asia-east2/AddMessage'),
      body: jsonEncode({
        'uid': uid,
        'chat_id': chat_id,
        'content': content,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    //Do something with response, Idk what yet
  }

  Stream<List<Message>> load_messages(String match_id) {
    print("Match Id: " + match_id.toString());
    return _firestore
        .collection('Matches')
        .doc(match_id)
        .collection('Messages')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) {
      print('Received snapshot: $snapshot');
      return snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList();
    }).handleError((error) => print('Error loading messages: $error'));
  }

  Future<void> set_token(String uid) async {
    try{
      String token = await _messagingService.get_token() as String;
      print("TOKEN FOR USER " + token.toString());
      _firestore.collection('Users').doc(uid).update({
        'fcm_token': token,
      });
      print("SET TOKEN FOR UID: " + uid.toString());
    }
    catch (error){
      print("Setting token failed: " + error.toString());
    }
  }

  Future<bool> is_document_there(String uid) async {
    DocumentReference user_doc_ref = _firestore.collection('Users').doc(uid);
    DocumentSnapshot user_doc_snapshot = await user_doc_ref.get();
    bool doc_exists;
    doc_exists = user_doc_snapshot.exists;
    return doc_exists;
  }
}
