import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_app/models/match_model.dart';

@lazySingleton
class FirestoreService{
  final _firestore = FirebaseFirestore.instance;  

  // ignore: non_constant_identifier_names
  Stream<List<ChatMatch>> get_old_matches(String uid){
      //query to get the 5 most recent chats where last_message != null and where uid is in the array users
      return _firestore.collection('Matches')
        .where('users', arrayContains:  uid)
        .where('last_message', isNull: false)
        .orderBy("timestamp", descending: true)
        .limit(5)
        .snapshots()
        //define the fromDocument function
        .map((snapshot) => snapshot.docs.map((doc) => ChatMatch.fromDocument(doc)).toList())
        .handleError((error) {
          print("Error fetching old matches: $error");
        });
  }

  // ignore: non_constant_identifier_names
  Stream<List<ChatMatch>> get_new_matches(String uid){
      //query to get the 5 most recent chats where last_messages == null and where uid is in the array users
      return _firestore.collection('Matches')
        .where('users', arrayContains:  uid)
        .where('last_message', isNull: true)
        .orderBy("timestamp", descending: true)
        .limit(5)
        .snapshots()
        //define the fromDocument function
        .map((snapshot) => snapshot.docs.map((doc) => ChatMatch.fromDocument(doc)).toList())
        .handleError((error) {
          print("Error fetching new matches: $error");
        });
  }
}