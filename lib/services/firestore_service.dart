import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_app/models/match_model.dart';
import 'package:stacked_app/models/message_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

@lazySingleton
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // FirestoreService(){
  //   _firestore.settings = const Settings(
  //     host: 'localhost:8084',
  //     sslEnabled: true,
  //     persistenceEnabled: false,
  //   );
  //   print("Firestore settings: " + _firestore.settings.toString());
  // }

  FirestoreService(){
    _firestore.useFirestoreEmulator('localhost',8085);
    print("I am using the emulator: " + _firestore.settings.toString());
  }

  // ignore: non_constant_identifier_names
  //Stream<List<ChatMatch>> get_old_matches(String uid) {
  // return Stream.fromFuture(
  //   () async {
  //     final response = await http.post(
  //       Uri.parse('http://127.0.0.1:5003/qaabl-mobile-dev/asia-east2/GetOldMatches'),
  //       body: jsonEncode({
  //         'uid': uid,
  //       }),
  //       headers: {'Content-Type': 'application/json'},
  //     );

  //     if (response.statusCode == 200) {
  //       print("HEre2");
  //       final List<dynamic> data = jsonDecode(response.body);
  //       print("Data is: "+data.toString());
  //       try {
  //         final List<ChatMatch> matches = data.map<ChatMatch>((e) {
  //           print("Mapping: $e");
  //           return ChatMatch.fromJson(e, uid);
  //         }).toList();
  //         print("matches: " + matches.toString());
  //         return matches;
  //       } catch (e) {
  //         print("Error during mapping: $e");
  //         throw e; // rethrow the error after logging it
  //       }
  //     } else {
  //       throw Exception('Failed to load new matches');
  //     }
  //   }()
  // );
//}
    
    Stream<List<ChatMatch>> get_old_matches(String uid) {
    print("user making request is: " + uid.toString());
    return _firestore.collection('Matches')
        .where('users', arrayContains: uid)
        .where('has_message', isEqualTo: true)
        .orderBy('timestamp', descending: true)
        .limit(5)
        .snapshots()
        .asyncMap((snapshot) async {
          print("asyncMap start, snapshot.docs.length: ${snapshot.docs.length}");
          print("Snapshot metadata, isFromCache: ${snapshot.metadata.isFromCache}, hasPendingWrites: ${snapshot.metadata.hasPendingWrites}");

          if (snapshot.docs.isEmpty) {
            print("No documents found in snapshot");
          } else {
            print("Documents found: ${snapshot.docs.map((doc) => doc.id).join(', ')}");
          }
      //getting the name of the other user
      //using futures to fetch in parallel
      final futures = <Future<ChatMatch>>[];
      for (final doc in snapshot.docs) {
        final match = ChatMatch.fromDocument(doc, uid);
        final otherUserId = match.other_user_id;
        final future = get_user_info(otherUserId).then((userInfo) {
          match.other_user_name = userInfo['name']; // Ensure this is a mutable property
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

  //Stream<List<ChatMatch>> get_new_matches(String uid) {
//   return Stream.fromFuture(
//     () async {
//       final response = await http.post(
//         Uri.parse('http://127.0.0.1:5003/qaabl-mobile-dev/asia-east2/GetNewMatches'),
//         body: jsonEncode({
//           'uid': uid,
//         }),
//         headers: {'Content-Type': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         print("HEre2");
//         final List<dynamic> data = jsonDecode(response.body);
//         print("Data is: "+data.toString());
//         try {
//           final List<ChatMatch> matches = data.map<ChatMatch>((e) {
//             print("Mapping: $e");
//             return ChatMatch.fromJson(e, uid);
//           }).toList();
//           print("matches: " + matches.toString());
//           return matches;
//         } catch (e) {
//           print("Error during mapping: $e");
//           throw e; // rethrow the error after logging it
//         }
//       } else {
//         throw Exception('Failed to load new matches');
//       }
//     }()
//   );
// }

  //ignore: non_constant_identifier_names
  Stream<List<ChatMatch>> get_new_matches(String uid) {
    print("get new matches start");
    //query to return the new chats
    return _firestore.collection('Matches')
        .where('users', arrayContains: uid)
        .where('has_message', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        .limit(5)
        .snapshots()
        .asyncMap((snapshot) async {
          print("asyncMap start, snapshot.docs.length: ${snapshot.docs.length}");
          print("Snapshot metadata, isFromCache: ${snapshot.metadata.isFromCache}, hasPendingWrites: ${snapshot.metadata.hasPendingWrites}");

          if (snapshot.docs.isEmpty) {
            print("No documents found in snapshot");
          } else {
            print("Documents found: ${snapshot.docs.map((doc) => doc.id).join(', ')}");
          }
      //getting the name of the other user
      //using futures to fetch in parallel
      final futures = <Future<ChatMatch>>[];
      for (final doc in snapshot.docs) {
        final match = ChatMatch.fromDocument(doc, uid);
        final otherUserId = match.other_user_id; // Ensure this is the correct property name
        final future = get_user_info(otherUserId).then((userInfo) {
          match.other_user_name = userInfo['name']; // Ensure this is a mutable property
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
      return {
      'name': name,
      'image_index': imageIndex
      };
    } catch (e) {
      print('Error fetching user info: $e');
      return {
      'name': 'No Name',
      'imageIndex': 0
    };
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
  // return Stream.fromFuture(
  //   () async {
  //     try {
  //       final response = await http.post(
  //         Uri.parse('http://127.0.0.1:5003/qaabl-mobile-dev/asia-east2/LoadMessages'),
  //         body: jsonEncode({
  //           'match_id': match_id,
  //         }),
  //         headers: {'Content-Type': 'application/json'},
  //       );

  //       if (response.statusCode == 200) {
  //         print("here bro");
  //         final List<dynamic> list = jsonDecode(response.body);
  //         final messages = list.map((e) => Message.fromJson(e)).toList();
  //         return messages;
  //       } else {
  //         throw Exception('Failed to load messages');
  //       }
  //     } catch (e) {
  //       print("Error during mapping: $e");
  //       throw e; // rethrow the error after logging it
  //     }
  //   }()
  // );
  // } 

    return _firestore.collection('Matches').doc(match_id).collection('Messages')
          .orderBy('timestamp', descending: true)
          .limit(10)
          .snapshots()
          .map((snapshot) {
            print('Received snapshot: $snapshot');
            return snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList();
          })
          .handleError((error) => print('Error loading messages: $error'));
  }
}
