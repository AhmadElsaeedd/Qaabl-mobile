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
      print("User UID: " + uid.toString());

      //query to get the 5 most recent chats where last_message != null and where uid is in the array users
      return _firestore.collection('Matches')
        .where('users', arrayContains:  uid)
        .where('has_message', isEqualTo: true)
        .orderBy('timestamp', descending: true)
        .limit(5)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
          print("Document Data: ${doc.data()}");
          return ChatMatch.fromDocument(doc);
        }).toList())
        .handleError((error) {
          print("Error fetching old matches: $error");
        });
  }
  // ignore: non_constant_identifier_names
  // Stream<List<ChatMatch>> get_old_matches(String uid) {
  //   print("User UID: " + uid.toString());

  //   // Simplified query to get the first document in the 'Matches' collection
  //   return _firestore.collection('Matches')
  //     .limit(1)
  //     .snapshots()
  //     .map<List<ChatMatch>>((snapshot) { // Explicitly cast the mapped Stream
  //       print('Received snapshot: $snapshot');
  //       try {
  //         return snapshot.docs.map((doc) {
  //           print('Transforming doc: $doc');
  //           return ChatMatch.fromDocument(doc);
  //         }).toList();
  //       } catch (e, stackTrace) {
  //         print('Error transforming document: $e');
  //         print('StackTrace: $stackTrace');
  //         return [];
  //       }
  //     })
  //     .handleError((error) {
  //       print('Error fetching simplified query: $error');
  //     });
  // }



  // ignore: non_constant_identifier_names
  Stream<List<ChatMatch>> get_new_matches(String uid){
      print("User UID: " + uid.toString());
      //query to get the 5 most recent chats where last_messages == null and where uid is in the array users
      return _firestore.collection('Matches')
        .where('users', arrayContains:  uid)
        .where('has_message', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        .limit(5)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
          print("Document Data: ${doc.data()}");
          return ChatMatch.fromDocument(doc);
        }).toList())
        .handleError((error) {
          print("Error fetching new matches: $error");
        });
  }
}