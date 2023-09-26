import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked_app/models/message_model.dart';
import 'package:stacked_app/services/firestore_service.dart';


class ChatMatch {
  final String match_id;
  final List<String> users;
  final String other_user_id;
  late String other_user_name;
  final DateTime timestamp;
  final Message? last_message; //a Message object

  ChatMatch({
    required this.match_id,
    required this.users,
    required this.other_user_id,
    required this.timestamp,
    this.last_message,
  });

  factory ChatMatch.fromDocument(DocumentSnapshot doc, String uid) {
    final data = doc.data() as Map<String, dynamic>;
    final Map<String, dynamic>? lastMessageMap = data['last_message'] as Map<String, dynamic>?;
    Message? lastMessage;
    if (lastMessageMap != null && 
        lastMessageMap.containsKey('content') && 
        lastMessageMap.containsKey('timestamp') && 
        lastMessageMap.containsKey('sent_by')) {
      lastMessage = Message.fromMap(lastMessageMap);
    }

    //get the uid of the other user in the chat
    final List<String> usersList = List<String>.from(data['users'] ?? []);
    final String other_user_uid = usersList.firstWhere((user) => user != uid, orElse: () => '');

    return ChatMatch(
      match_id: doc.id,
      users: usersList,
      other_user_id: other_user_uid,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      last_message: lastMessage,
    );
  }
}