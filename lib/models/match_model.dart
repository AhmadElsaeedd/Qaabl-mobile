import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qaabl_mobile/models/message_model.dart';
// import 'package:qaabl_mobile/services/firestore_service.dart';

class ChatMatch {
  final String match_id;
  final List<String> users;
  final String other_user_id;
  late String other_user_name;
  final DateTime timestamp;
  final Message? last_message; //a Message object
  late int other_user_pic;
  late bool? last_message_sent_by_user;

  ChatMatch({
    required this.match_id,
    required this.users,
    required this.other_user_id,
    required this.other_user_name,
    required this.other_user_pic,
    required this.timestamp,
    this.last_message,
    required this.last_message_sent_by_user,
  });

  factory ChatMatch.fromDocument(DocumentSnapshot doc, String uid) {
    bool lastMessageSentByUser = false; // default value
    final data = doc.data() as Map<String, dynamic>;
    final Map<String, dynamic>? lastMessageMap =
        data['last_message'] as Map<String, dynamic>?;
    Message? lastMessage;
    if (lastMessageMap != null &&
        lastMessageMap.containsKey('content') &&
        lastMessageMap.containsKey('timestamp') &&
        lastMessageMap.containsKey('sent_by')) {
      lastMessage = Message.fromMap(lastMessageMap);
      if (lastMessage.sent_by == uid) {
        lastMessageSentByUser = true;
      }
    }

    //get the uid of the other user in the chat
    final List<String> usersList = List<String>.from(data['users'] ?? []);
    final String other_user_uid =
        usersList.firstWhere((user) => user != uid, orElse: () => '');

    final String? other_user_name = data['other_user_name'] as String?;

    print("Is last message sent by current user? " +
        lastMessageSentByUser.toString());
    //HERE

    return ChatMatch(
      match_id: doc.id,
      users: usersList,
      other_user_id: other_user_uid,
      other_user_name: other_user_name ?? 'Loading',
      other_user_pic: 0,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      last_message: lastMessage,
      last_message_sent_by_user: lastMessageSentByUser,
    );
  }
}
