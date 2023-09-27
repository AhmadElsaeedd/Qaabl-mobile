import 'package:stacked_app/app/app.locator.dart';
import 'package:stacked_app/app/app.router.dart';
import 'package:stacked_app/services/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_app/services/firestore_service.dart';
import 'package:stacked_services/stacked_services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:collection';
import 'package:stacked_app/models/match_model.dart';

class ChatsViewModel extends MultipleStreamViewModel {
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final _firestoreService = locator<FirestoreService>();

  // current user id, defined class level to be reusable in all methods
  String? uid;

  List<ChatMatch> new_matches = [];
  List<ChatMatch> old_matches = [];

  @override
  void onData(String key, data) {
    switch (key) {
      case 'new_chats':
        new_matches = data;
        break;
      case 'old_chats':
        old_matches = data;
        break;
    }
    rebuildUi();
  }

  @override
  Map<String, StreamData<List<ChatMatch>>> get streamsMap {
    final uid = _authenticationService.currentUser?.uid;
    if (uid == null) {
      _navigationService.replaceWithLoginView();
      return {};
    }
    print("User making the request is: " + uid.toString());

    return {
      'new_chats':
          StreamData<List<ChatMatch>>(_firestoreService.get_new_matches(uid)),
      'old_chats':
          StreamData<List<ChatMatch>>(_firestoreService.get_old_matches(uid)),
    };
  }

  void go_to_chat(String match_id, String user_name) {
    _navigationService.navigateToInChatView(matchid: match_id, username: user_name);
  }

  //We need to empty the input box of the chat after the chat is sent.
}
