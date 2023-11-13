import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';

class Message {
  final String content;
  final DateTime timestamp;
  final String sent_by;
  String reaction;

  Message({
    required this.content,
    required this.timestamp,
    required this.sent_by,
    required this.reaction,
  });

  factory Message.fromMap(Map<String, dynamic> data, String keyHex) {
    final timestampData = data['timestamp'];
    final timestamp =
        timestampData is Timestamp ? timestampData.toDate() : DateTime.now();

    String decryptedContent = 'Unknown content';
    if (data.containsKey('encryptedData') && data.containsKey('iv')) {
      final encryptedData = data['encryptedData'] as String;
      final iv = data['iv'] as String;
      decryptedContent = decryptAES(encryptedData, iv, keyHex);
    } else if (data.containsKey('content')) {
      decryptedContent = data['content'] as String;
    }

    final sent_by =
        data['sent_by'] is String ? data['sent_by'] : 'Unknown sender';
    final reaction =
        data['reaction'] is String ? data['reaction'] : 'No reaction';

    return Message(
      content: decryptedContent,
      timestamp: timestamp,
      sent_by: sent_by,
      reaction: reaction,
    );
  }

  //from Json method
  // factory Message.fromJson(Map<String, dynamic> json) {
  // try {
  //   final Map<String, dynamic>? timestampMap = json['timestamp'] as Map<String, dynamic>?;
  //   DateTime timestamp;
  //   if (timestampMap != null) {
  //     final int seconds = (timestampMap['_seconds'] as num).toInt() * 1000;
  //     final int nanoseconds = (timestampMap['_nanoseconds'] as num).toInt() ~/ 1000000;
  //     timestamp = DateTime.fromMillisecondsSinceEpoch(seconds + nanoseconds);
  //   } else {
  //     throw Exception('Timestamp is null or not in correct format');
  //   }
  //   return Message(
  //     content: json['content'],
  //     sent_by: json['sent_by'],
  //     timestamp: timestamp, // Use the timestamp created from the timestampMap
  //   );
  // } catch (error) {
  //   print('Error mapping data in from json: $error');
  //   return Message(
  //     content: 'Error loading message',
  //     timestamp: DateTime.now(),
  //     sent_by: 'System',
  //   );
  // }
}

String decryptAES(String encryptedData, String ivHex, String keyHex) {
  final key = encrypt.Key.fromUtf8(hexToUtf8(keyHex));
  final iv = encrypt.IV.fromUtf8(hexToUtf8(ivHex));
  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

  final encrypted = encrypt.Encrypted.from64(encryptedData);
  return encrypter.decrypt(encrypted, iv: iv);
}

String hexToUtf8(String hexString) {
  List<int> bytes = [];
  for (var i = 0; i < hexString.length; i += 2) {
    bytes.add(int.parse(hexString.substring(i, i + 2), radix: 16));
  }
  return utf8.decode(bytes);
}
