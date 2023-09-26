import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_app/models/match_model.dart';

@lazySingleton
class FirestoreService{
  final _firestore = FirebaseFirestore.instance;  

  // FirestoreService(){
  //   _firestore.settings = const Settings(
  //     host: 'localhost:8081',
  //     sslEnabled: false,
  //     persistenceEnabled: false,
  //   );
  //   print("Firestore Settings: ${_firestore.settings}");
  // }

  // ignore: non_constant_identifier_names
  Stream<List<ChatMatch>> get_old_matches(String uid){
      //query to get the 5 most recent chats where last_message != null and where uid is in the array users
      return _firestore.collection('Matches')
        .where('users', arrayContains: uid)
        .where('has_message', isEqualTo: true)
        .orderBy('timestamp', descending: true)
        .limit(5)
        .snapshots()
        .asyncMap((snapshot) async {
          //getting the name of the other user
          //using futures to fetch in parallel
          final futures = <Future<ChatMatch>>[];
          for (final doc in snapshot.docs) {
            final match = ChatMatch.fromDocument(doc, uid);
            final otherUserId = match.other_user_id;
            final future = get_user_name(otherUserId).then((userName) {
              match.other_user_name = userName;
              return match;
            });
            futures.add(future);
          }
          final matches = await Future.wait(futures);
          return matches;
        })
        .handleError((error) {
          print("Error fetching old matches: $error");
        });
  }

  // ignore: non_constant_identifier_names
  Stream<List<ChatMatch>> get_new_matches(String uid) {
    //query to return the new chats
    return _firestore.collection('Matches')
        .where('users', arrayContains: uid)
        .where('has_message', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        .limit(5)
        .snapshots()
        .asyncMap((snapshot) async {
          //getting the name of the other user
          //using futures to fetch in parallel
          final futures = <Future<ChatMatch>>[];
          for (final doc in snapshot.docs) {
            final match = ChatMatch.fromDocument(doc, uid);
            final otherUserId = match.other_user_id; // Ensure this is the correct property name
            final future = get_user_name(otherUserId).then((userName) {
              match.other_user_name = userName; // Ensure this is a mutable property
              return match;
            });
            futures.add(future);
          }
          final matches = await Future.wait(futures);
          return matches;
        })
        .handleError((error) {
          print("Error fetching new matches: $error");
        });
  }


  // ignore: non_constant_identifier_names
  Future<String> get_user_name(String uid) async{
    try {
      final doc = await _firestore.collection('Users').doc(uid).get();
      final data = doc.data() as Map<String, dynamic>;
      return data['name'] ?? 'No Name';
    } catch (e) {
      print('Error fetching user name: $e');
      return 'No Name';
    }
  }

  //function to add a message to the chat
  Future<void> send_message(String chat_id, String content, String uid){
    
  }

}