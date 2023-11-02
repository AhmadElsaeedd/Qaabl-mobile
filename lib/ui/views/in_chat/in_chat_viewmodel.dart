import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_app/app/app.locator.dart';
import 'package:stacked_app/app/app.router.dart';
import 'package:stacked_app/services/auth_service.dart';
import 'package:stacked_app/services/firestore_service.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_app/models/message_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class InChatViewModel extends BaseViewModel {
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final _firestoreService = locator<FirestoreService>();

  String? uid;

  //declare the matchID
  final String match_id;

  //declare the name of the other user in chat
  final String user_name;

  final int user_pic;

  List<Message> displayed_messages = [];

  final String other_user_id;

  Map<String, dynamic>? user_data;

  DocumentSnapshot? lastVisibleMessageSnapshot;

  bool first_load = false;

  //the constructor needs to know which chat it is going to
  InChatViewModel(
      this.match_id, this.user_name, this.user_pic, this.other_user_id) {
    uid = _authenticationService.currentUser?.uid;
    if (uid == null) {
      _navigationService.replaceWithLoginView();
    }
    first_load = true;
    // _listenToNewMessages();
    _listenToMessages();
    loadMessagesBatch();
  }

  void dispose() {
    _newMessagesSubscription?.cancel();
    super.dispose();
  }

  Future<void> go_to_chats() async {
    _navigationService.back();
  }

  StreamSubscription? _newMessagesSubscription;

  // void _listenToNewMessages() {
  //   _newMessagesSubscription =
  //       _firestoreService.listenToNewMessages(match_id).listen((newMessages) {
  //     print("Subscribed and in function");
  //     final filteredMessages =
  //         newMessages.where((message) => message.sent_by != uid).toList();
  //     if (filteredMessages.isNotEmpty) {
  //       print("I am inserting");
  //       displayed_messages.insertAll(0, filteredMessages);
  //       rebuildUi();
  //     }
  //   });
  // }

  void _listenToMessages() {
    _newMessagesSubscription =
        _firestoreService.listenToMessages(match_id).listen(
      (List<DocumentChange> documentChanges) {
        bool shouldRebuildUi = false;

        for (var change in documentChanges) {
          print("some change happened");
          // Create a Message instance from the DocumentSnapshot
          Message message =
              Message.fromMap(change.doc.data() as Map<String, dynamic>);
          print("the message is: " + message.toString());
          int index = displayed_messages
              .indexWhere((m) => m.content == message.content);
          print("It's index is: " + index.toString());

          switch (change.type) {
            case DocumentChangeType.added:
              if (index == -1) {
                //if it's a new message, and is not by the user add it
                if (first_load != true && message.sent_by != uid) {
                  print("I am inserting");
                  displayed_messages.insert(0, message);
                  shouldRebuildUi = true;
                }
              }
              break;
            case DocumentChangeType.modified:
              if (index != -1) {
                // If the message exists, update it
                displayed_messages[index] = message;
                shouldRebuildUi = true;
              }
              break;
            case DocumentChangeType.removed:
              if (index != -1) {
                // If the message exists, remove it
                displayed_messages.removeAt(index);
                shouldRebuildUi = true;
              }
              break;
          }
        }

        if (shouldRebuildUi) {
          // If there's any UI change, call a method to update the UI
          rebuildUi(); // Or however you trigger a rebuild in your architecture
        }
      },
    );
  }

  Future<void> loadMessagesBatch() async {
    try {
      final pair = await _firestoreService.getMessagesBatch(
          match_id, lastVisibleMessageSnapshot);
      final messages = pair.first;
      if (messages.isNotEmpty) {
        lastVisibleMessageSnapshot = pair.second;
        if (first_load) {
          displayed_messages.insertAll(0, messages);
          first_load = false;
        } else {
          displayed_messages.insertAll(displayed_messages.length, messages);
        }
        rebuildUi();
      }
    } catch (e) {
      print('Error loading messages batch: $e');
    }
  }

  //function that adds a message to the chat
  void send_message(String content) {
    //pass a "fake" message to the UI so the UI is updated immediately
    final Message new_message = Message(
      content: content,
      sent_by: uid!,
      timestamp: Timestamp.now().toDate(),
      reaction: "",
    );
    displayed_messages.insert(0, new_message);
    rebuildUi();

    _firestoreService.send_message(match_id, content, uid!);
  }

  void react_to_message(String reaction, Message message) {
    //find the instance of message inside displayed_messages and add the reaction to it
    // Find the index of the message in displayed_messages
    int? index = displayed_messages.indexWhere((msg) =>
        msg.timestamp == message.timestamp && msg.sent_by == message.sent_by);

    if (index != -1) {
      displayed_messages[index].reaction = reaction;
      rebuildUi();
    }

    _firestoreService.reaction_to_message(match_id, reaction, message.content);
  }

  Future<void> view_profile_data(String uid) async {
    user_data = await get_user_data(uid);
    rebuildUi();
  }

  Future<Map<String, dynamic>> get_user_data(String uid) async {
    final response = await http.post(
      //production url
      Uri.parse(
          'https://asia-east2-qaabl-mobile-dev.cloudfunctions.net/GetProfileData'),
      //testing url
      // Uri.parse(
      //     'http://127.0.0.1:5003/qaabl-mobile-dev/asia-east2/GetProfileData'),
      body: jsonEncode({
        'uid': uid,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      // If the server returns an error, throw an exception
      throw Exception('Failed to get percentage');
    }
  }

  Future<void> delete_chat(String match_id, String other_user_id) async {
    await http.post(
      //production url
      Uri.parse(
          'https://asia-east2-qaabl-mobile-dev.cloudfunctions.net/DeleteMatch'),
      //testing url
      // Uri.parse(
      //     'http://127.0.0.1:5003/qaabl-mobile-dev/asia-east2/DeleteMatch'),
      body: jsonEncode({
        'match_id': match_id,
        'user1_id': uid,
        'user2_id': other_user_id,
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }
}
