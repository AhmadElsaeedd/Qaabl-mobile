import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import 'package:qaabl_mobile/models/match_model.dart';
import 'package:qaabl_mobile/models/message_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:qaabl_mobile/app/app.locator.dart';
import 'package:qaabl_mobile/services/messaging_service.dart';
import 'package:qaabl_mobile/services/mixpanel_service.dart';

@lazySingleton
class FirestoreService {
  final _messagingService = locator<MessagingService>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _mixpanelService = locator<MixpanelService>();

  // FirestoreService() {
  //   _firestore.useFirestoreEmulator('192.168.1.101', 8085);
  // }

  Stream<List<ChatMatch>> get_old_matches(String uid) {
    return _firestore
        .collection('Matches')
        .where('users', arrayContains: uid)
        .where('has_message', isEqualTo: true)
        .orderBy('last_message_timestamp', descending: true)
        .limit(10)
        .snapshots()
        .asyncMap((snapshot) async {
      if (snapshot.docs.isEmpty) {
        print("No documents found in snapshot");
      } else {
        print("Documents found");
      }
      //getting the name of the other user
      //using futures to fetch in parallel
      final futures = <Future<ChatMatch>>[];
      for (final doc in snapshot.docs) {
        print("I am here");
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
      print("number of old matches: ${matches.length}");
      return matches;
    }).handleError((error) {
      print("Error fetching old matches: $error");
    });
  }

  //ignore: non_constant_identifier_names
  Stream<List<ChatMatch>> get_new_matches(String uid) {
    //query to return the new chats
    return _firestore
        .collection('Matches')
        .where('users', arrayContains: uid)
        .where('has_message', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        .limit(5)
        .snapshots()
        .asyncMap((snapshot) async {
      if (snapshot.docs.isEmpty) {
        print("No documents found in snapshot");
      } else {
        print("Documents found");
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
      return matches;
    }).handleError((error) {
      print("Error fetching new matches: $error");
    });
  }

  // ignore: non_constant_identifier_names
  Future<Map<String, dynamic>> get_user_info(String uid) async {
    try {
      print("The uid is: " + uid);
      final doc = await _firestore.collection('Users').doc(uid).get();
      print("Doc is: " + doc.toString());
      if (doc.exists) {
        print("I am here");
        final data = doc.data() as Map<String, dynamic>;
        String name = data['name'] ?? 'No Name';
        int imageIndex = data['image_index'];
        return {'name': name, 'image_index': imageIndex};
      } else {
        String name = "No Name";
        int imageIndex = 0;
        return {'name': name, 'image_index': imageIndex};
      }
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
      Uri.parse(
          'https://asia-east2-qaabl-mobile-dev.cloudfunctions.net/AddMessage'),
      //testing url
      // Uri.parse('http://127.0.0.1:5003/qaabl-mobile-dev/asia-east2/AddMessage'),
      // Uri.parse(
      //     'http://192.168.1.101:5003/qaabl-mobile-dev/asia-east2/AddMessage'),
      body: jsonEncode({
        'uid': uid,
        'chat_id': chat_id,
        'content': content,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    _mixpanelService.mixpanel.track("Sent Message");
    //Do something with response, Idk what yet
  }

  Future<void> reaction_to_message(
      String chat_id, String reaction, String content) async {
    await http.post(
      //production url
      Uri.parse(
          'https://asia-east2-qaabl-mobile-dev.cloudfunctions.net/MessageReaction'),
      //testing url
      // Uri.parse(
      //     'http://127.0.0.1:5003/qaabl-mobile-dev/asia-east2/MessageReaction'),
      // Uri.parse(
      //     'http://192.168.1.101:5003/qaabl-mobile-dev/asia-east2/MessageReaction'),
      body: jsonEncode({
        'reaction': reaction,
        'chat_id': chat_id,
        'content': content,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    _mixpanelService.mixpanel.track("Message reaction");
  }

  Future<Pair<List<Message>, DocumentSnapshot?>> getMessagesBatch(
      String match_id,
      [DocumentSnapshot? lastVisibleMessageSnapshot]) async {
    Query query = _firestore
        .collection('Matches')
        .doc(match_id)
        .collection('Messages')
        .orderBy('timestamp', descending: true)
        .limit(10);

    if (lastVisibleMessageSnapshot != null) {
      query = query.startAfterDocument(lastVisibleMessageSnapshot);
    }

    final snapshot = await query.get();
    final messages = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Message.fromMap(data);
    }).toList();

    final lastDoc = snapshot.docs.isEmpty ? null : snapshot.docs.last;

    return Pair(messages, lastDoc);
  }

  Stream<List<DocumentChange>> listenToMessages(String match_id) {
    final query = _firestore
        .collection('Matches')
        .doc(match_id)
        .collection('Messages')
        .orderBy('timestamp', descending: true)
        .snapshots();

    return query.map((snapshot) {
      return snapshot.docChanges;
    });
  }

  Future<void> set_token(String uid) async {
    try {
      String token = await _messagingService.get_token() as String;
      _firestore.collection('Users').doc(uid).update({
        'fcm_token': token,
      });
      print("SET TOKEN FOR UID: " + uid.toString());
    } catch (error) {
      print("Setting token failed: " + error.toString());
    }
  }

  Future<bool> is_document_there(String uid) async {
    print("uid of caller is: " + uid);
    DocumentReference user_doc_ref = _firestore.collection('Users').doc(uid);
    DocumentSnapshot user_doc_snapshot = await user_doc_ref.get();
    bool doc_exists;
    doc_exists = user_doc_snapshot.exists;
    return doc_exists;
  }
}

class Pair<T, U> {
  final T first;
  final U second;

  Pair(this.first, this.second);
}
