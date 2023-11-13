import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';

class Message {
  final String content;
  final DateTime timestamp;
  final String sent_by;
  String reaction;

  static String _keyHex =
      "6c3ea1572704708327e3a50112a0f99f0ddf7243c20aaf1db24545fa14d035a2";

  Message({
    required this.content,
    required this.timestamp,
    required this.sent_by,
    required this.reaction,
  });

  factory Message.fromMap(Map<String, dynamic> data) {
    final timestampData = data['timestamp'];
    final timestamp =
        timestampData is Timestamp ? timestampData.toDate() : DateTime.now();

    final sent_by = data['sent_by'] ?? 'Unknown sender';
    final reaction = data['reaction'] ?? 'No reaction';

    String content;
    if (data.containsKey('content') && data['content'] is Map) {
      final contentData = data['content'] as Map<String, dynamic>;
      if (contentData.containsKey('encryptedData') &&
          contentData.containsKey('iv')) {
        final encryptedData = contentData['encryptedData'];
        final iv = contentData['iv'];
        content = decryptAES(encryptedData, iv, _keyHex);
      } else {
        content = 'Unknown content';
      }
    } else {
      content = data['content'] ?? 'Unknown content';
    }

    return Message(
      content: content,
      timestamp: timestamp,
      sent_by: sent_by,
      reaction: reaction,
    );
  }
}

String decryptAES(String encryptedDataHex, String ivHex, String keyHex) {
  // Convert hex strings to byte arrays
  final List<int> keyListInt = hex.decode(keyHex);
  final List<int> ivListInt = hex.decode(ivHex);
  final List<int> encryptedDataListInt = hex.decode(encryptedDataHex);

  // Convert List<int> to Uint8List
  final Uint8List keyBytes = Uint8List.fromList(keyListInt);
  final Uint8List ivBytes = Uint8List.fromList(ivListInt);
  final Uint8List encryptedDataBytes = Uint8List.fromList(encryptedDataListInt);

  // Use the byte arrays to create the key and IV for the encryption
  final key = encrypt.Key(keyBytes);
  final iv = encrypt.IV(ivBytes);

  // Create the encrypter using the AES algorithm in CBC mode
  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

  // Use the encrypter to decrypt the data
  final encrypted = encrypt.Encrypted(encryptedDataBytes);
  return encrypter.decrypt(encrypted, iv: iv);
}
