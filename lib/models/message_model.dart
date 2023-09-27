import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String content;
  final DateTime timestamp;
  final String sent_by;

  Message({
    required this.content,
    required this.timestamp,
    required this.sent_by,
  });

  factory Message.fromMap(Map<String, dynamic> data) {
    try{
        print("Message: "+ data.toString());
        return Message(
          content: data['content'] as String,
          timestamp: (data['timestamp'] as Timestamp).toDate(),
          sent_by: data['sent_by'] as String,
        );
    }
    catch (error){
      print('Error mapping data: $error');
      return Message(
        content: 'Error loading message',
        timestamp: DateTime.now(),
        sent_by: 'System',
      );
    }
  }
}
