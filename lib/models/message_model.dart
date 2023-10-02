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
      final timestampMap = data['timestamp'] as Map<String, dynamic>;
      final timestamp = DateTime.fromMillisecondsSinceEpoch(
        timestampMap['_seconds'] * 1000 + timestampMap['_nanoseconds'] / 1000000);
        print("Message: "+ data.toString());
        return Message(
          content: data['content'] as String,
          timestamp: (data['timestamp'] as Timestamp).toDate(),
          sent_by: data['sent_by'] as String,
        );
    }
    catch (error){
      print('Error mapping data in from map: $error');
      return Message(
        content: 'Error loading message',
        timestamp: DateTime.now(),
        sent_by: 'System',
      );
    }
  }

  //from Json method
  factory Message.fromJson(Map<String, dynamic> json) {
  try {
    final Map<String, dynamic>? timestampMap = json['timestamp'] as Map<String, dynamic>?;
    DateTime timestamp;
    if (timestampMap != null) {
      final int seconds = (timestampMap['_seconds'] as num).toInt() * 1000;
      final int nanoseconds = (timestampMap['_nanoseconds'] as num).toInt() ~/ 1000000;
      timestamp = DateTime.fromMillisecondsSinceEpoch(seconds + nanoseconds);
    } else {
      throw Exception('Timestamp is null or not in correct format');
    }
    return Message(
      content: json['content'],
      sent_by: json['sent_by'],
      timestamp: timestamp, // Use the timestamp created from the timestampMap
    );
  } catch (error) {
    print('Error mapping data in from json: $error');
    return Message(
      content: 'Error loading message',
      timestamp: DateTime.now(),
      sent_by: 'System',
    );
  }
}
}
