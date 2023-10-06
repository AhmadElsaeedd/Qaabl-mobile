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

class InChatViewModel extends StreamViewModel {
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

  //the constructor needs to know which chat it is going to
  InChatViewModel(
      this.match_id, this.user_name, this.user_pic, this.other_user_id);

  Future<void> go_to_chats() async {
    print("I AM GOING BACK");
    _navigationService.back();
  }

  //implement the stream getter, that listens to messages in the chat
  @override
  Stream<List<Message>> get stream {
    print('Subscribing to stream');
    uid = _authenticationService.currentUser?.uid;
    if (uid == null) {
      _navigationService.replaceWithLoginView();
      return Stream.value([]);
    }
    return _firestoreService.load_messages(match_id).map((list) {
      displayed_messages = list;
      return list;
    });
  }

  //implement function that adds a message to the chat
  void send_message(String content) {
    //pass a "fake" message to the UI so the UI is updated immediately
    final Message new_message = Message(
      content: content,
      sent_by: uid!,
      timestamp: Timestamp.now().toDate(),
    );
    displayed_messages.insert(0, new_message);
    rebuildUi();

    _firestoreService.send_message(match_id, content, uid!);
  }

  Future<void> view_profile_data(String uid) async {
    user_data = await get_user_data(uid);
    rebuildUi();
  }

  Future<Map<String, dynamic>> get_user_data(String uid) async {
    final response = await http.post(
      //production url
      // Uri.parse(
      //     'https://asia-east2-qaabl-mobile-dev.cloudfunctions.net/GetProfileData'),
      //testing url
      Uri.parse(
          'http://127.0.0.1:5003/qaabl-mobile-dev/asia-east2/GetProfileData'),
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
      // Uri.parse(
      //     'https://asia-east2-qaabl-mobile-dev.cloudfunctions.net/GetProfileData'),
      //testing url
      Uri.parse(
          'http://127.0.0.1:5003/qaabl-mobile-dev/asia-east2/DeleteMatch'),
      body: jsonEncode({
        'match_id': match_id,
        'user1_id': uid,
        'user2_id': other_user_id,
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }
}
