import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked_app/models/message_model.dart';


class ChatMatch {
  final String match_id;
  final List<String> users;
  final DateTime timestamp;
  final Message? last_message; //a Message object

  ChatMatch({
    required this.match_id,
    required this.users,
    required this.timestamp,
    this.last_message,
  });

  factory ChatMatch.fromDocument(DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>;
  final Map<String, dynamic>? lastMessageMap = data['last_message'] as Map<String, dynamic>?;
  Message? lastMessage;
  if (lastMessageMap != null && 
      lastMessageMap.containsKey('content') && 
      lastMessageMap.containsKey('timestamp') && 
      lastMessageMap.containsKey('sent_by')) {
    lastMessage = Message.fromMap(lastMessageMap);
  }
  return ChatMatch(
    match_id: doc.id,
    users: List<String>.from(data['users'] ?? []),
    timestamp: (data['timestamp'] as Timestamp).toDate(),
    last_message: lastMessage,
  );
}
}