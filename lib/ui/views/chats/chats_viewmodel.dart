import 'package:qaabl_mobile/app/app.locator.dart';
import 'package:qaabl_mobile/app/app.router.dart';
import 'package:qaabl_mobile/services/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:qaabl_mobile/services/firestore_service.dart';
import 'package:stacked_services/stacked_services.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'dart:collection';
import 'package:qaabl_mobile/models/match_model.dart';
import 'package:qaabl_mobile/services/mixpanel_service.dart';

class ChatsViewModel extends MultipleStreamViewModel {
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final _firestoreService = locator<FirestoreService>();
  final _mixpanelService = locator<MixpanelService>();

  String? current_page;

  // current user id, defined class level to be reusable in all methods
  String? uid;

  List<ChatMatch> new_matches = [];
  List<ChatMatch> old_matches = [];

  bool isLoading = true;

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
    isLoading = false;
    rebuildUi();
  }

  @override
  Map<String, StreamData<List<ChatMatch>>> get streamsMap {
    final uid = _authenticationService.currentUser?.uid;
    if (uid == null) {
      _navigationService.replaceWithLoginView();
      return {};
    }
    current_page = "chats";
    return {
      'new_chats':
          StreamData<List<ChatMatch>>(_firestoreService.get_new_matches(uid)),
      'old_chats':
          StreamData<List<ChatMatch>>(_firestoreService.get_old_matches(uid)),
    };
  }

  void go_to_chat(
      String match_id, String user_name, int user_pic, String other_user_id) {
    _navigationService.navigateToInChatView(
        matchid: match_id,
        username: user_name,
        userpic: user_pic,
        otheruser_id: other_user_id);
    _mixpanelService.mixpanel.track("Directed to chat");
  }

  void go_to_profile() {
    _navigationService.replaceWithProfileView();
  }

  void go_to_home() {
    _navigationService.replaceWithHomeView();
  }

  void go_to_chats() {
    _navigationService.replaceWithChatsView();
  }

  void viewedChatPage() {
    print('visited chat page');
    _mixpanelService.mixpanel.track("Visited chat page");
  }
}
