// ignore_for_file: non_constant_identifier_names

//import 'package:stacked_app/app/app.bottomsheets.dart';
//import 'package:stacked_app/app/app.dialogs.dart';
import 'package:intl/intl.dart';
import 'package:qaabl_mobile/app/app.locator.dart';
import 'package:qaabl_mobile/app/app.router.dart';
import 'package:qaabl_mobile/services/auth_service.dart';
//import 'package:stacked_app/ui/common/app_strings.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:collection';
import 'package:qaabl_mobile/services/firestore_service.dart';
import 'package:qaabl_mobile/services/mixpanel_service.dart';

class HomeViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final _firestoreService = locator<FirestoreService>();
  final _mixpanelService = locator<MixpanelService>();

  String? current_page;

  // current user id, defined class level to be reusable in all methods
  String? uid;

  //logic flags
  bool? first_load;
  bool no_more_users = false;
  bool user_continues = true;
  bool last_user = false;
  bool replaying = false;

  Map<String, dynamic>? previous_user;
  Map<String, dynamic>? nextUser;

  List<Map<String, dynamic>>? user_notes;

  // constructor runs whenever the page is loaded or reloaded
  HomeViewModel() {
    // get the uid of the user
    uid = _authenticationService.currentUser?.uid;
    if (uid == null) {
      _navigationService.replaceWithLoginView();
    }
    current_page = "home";
    //logic flags
    first_load = true;
    no_more_users = false;
    user_continues = true;
    set_token_by_waiting_for_document();
  }

  //data structure that will hold the users info
  Queue<Map<String, dynamic>> users_queue = Queue();
  //list of users id's for easy access
  Set<String> user_Ids_in_queue = <String>{};
  Set<String> seen_users = <String>{};

  //A function that sends an HTTP request to a cloud function getUsers()
  Future<void> getUsers() async {
    try {
      final response = await http.post(
        //production url
        // Uri.parse(
        //     'https://asia-east2-qaabl-mobile-dev.cloudfunctions.net/GetUsers'),
        //testing url
        Uri.parse('http://127.0.0.1:5003/qaabl-mobile-dev/asia-east2/GetUsers'),
        body: jsonEncode({
          'uid': uid,
          'users_queue_uids': user_Ids_in_queue.toList(),
        }),
        headers: {'Content-Type': 'application/json'},
      );
      //response of the function should contain 3 users with their UIDs and interests
      if (!(response.statusCode == 200 ||
          response.statusCode == 204 ||
          response.statusCode == 205))
        print("failed to go to cloud");
      else if (response.statusCode == 204) {
      } else if (response.statusCode == 205) {
        user_continues = false;
        rebuildUi();
      } else if (response.statusCode == 200) {
        List<dynamic> users = jsonDecode(response.body);
        for (var user in users) {
          // if user already exists in queue, skip them
          String user_Id = user['id'];
          if (!(user_Ids_in_queue.contains(user_Id) ||
              seen_users.contains(user_Id))) {
            users_queue.add(user);
            user_Ids_in_queue.add(user_Id);
            seen_users.add(user_Id);
          }
        }
      }

      if (users_queue.isEmpty) {
        no_more_users = true;
        rebuildUi();
      }

      // Rebuild UI in first load only
      if (first_load == true) {
        rebuildUi();
      }

      // Stop it from reloading infinitely
      first_load = false;
    } catch (e) {
      // Handle exception
      _dialogService.showConfirmationDialog(
        title: "Exception",
        description: "An exception occurred: $e",
      );
    }
  }

  // function to get next user
  Map<String, dynamic>? get_next_user() {
    if (users_queue.length == 1) {
      last_user = true;
      no_more_users = true;
      return users_queue.first;
    }
    //when the queue is empty after the first load or there is no more users or user shouldnt continue
    if ((no_more_users == true) ||
        (users_queue.length == 0 && first_load == false) ||
        (user_continues == false)) {
      no_more_users == true;
      return null;
    }
    // //refill the queue when needed, we want to maintain having users in the queue
    if ((users_queue.length < 10 || first_load == true) &&
        (no_more_users == false) &&
        (last_user == false)) {
      getUsers();
    }

    //when queue has users, show the first user and banish them from existence
    if (users_queue.isNotEmpty && user_continues == true) {
      return users_queue.first;
    }
    return null;
  }

  void replay_user() {
    replaying = true;
    nextUser = previous_user;
    rebuildUi();
  }

  //function that likes a user, server-side
  Future<void> like_user(String liked_user_uid, bool potential_match,
      String like_or_super_like) async {
    if (liked_user_uid == users_queue.first['id']) {
      previous_user = users_queue.first;
      users_queue.removeFirst();
    }
    //rebuild ui, meaning next user will be fetched
    rebuildUi();
    dynamic response;
    if (potential_match == true) {
      //create a match between 2 users
      response = await both_like_each_other(liked_user_uid);
    } else {
      //call the cloud function that likes a user
      response = await like_user_in_cloud(liked_user_uid, like_or_super_like);
    }

    //response of the function should contain true, that's it
    if (response.statusCode == 200) {
      //remove user from queue (already removed from the other queue when displaying)
      user_Ids_in_queue.remove(liked_user_uid);
      _mixpanelService.mixpanel.track("Liked user");
    } else if (response.statusCode == 204) {
      try {
        await both_like_each_other(liked_user_uid);
      } catch (e) {
        print("couldn't create a match: " + e.toString());
      }
    } else {
      print("failed to go to cloud");
    }
  }

  //ToDo: function that dislikes a user, server-side
  Future<void> dislike_user(String disliked_user_uid) async {
    previous_user = users_queue.removeFirst();
    //rebuild ui, meaning next user will be fetched
    rebuildUi();
    //call the cloud function that dislikes a user
    final response = await http.post(
      //add the url of the function here
      //production URL
      // Uri.parse(
      //     'https://asia-east2-qaabl-mobile-dev.cloudfunctions.net/DislikeUser'),
      //testing URL
      Uri.parse(
          'http://127.0.0.1:5003/qaabl-mobile-dev/asia-east2/DislikeUser'),
      body: jsonEncode({
        'user_uid': uid,
        'disliked_user_uid': disliked_user_uid,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    //response of the function should contain true, that's it
    if (response.statusCode == 200) {
      //remove user from queue (already removed from the other queue when displaying)
      user_Ids_in_queue.remove(disliked_user_uid);
      _mixpanelService.mixpanel.track("Disliked user");
    } else {
      print("failed to go to cloud");
    }
  }

  Future<void> leave_note(String liked_user_uid, String text) async {
    //Implement the calling of the cloud function here
    final response = await http.post(
      //add the url of the function here
      //production URL
      // Uri.parse(
      //     'https://asia-east2-qaabl-mobile-dev.cloudfunctions.net/LeaveNote'),
      //testing URL
      Uri.parse('http://127.0.0.1:5003/qaabl-mobile-dev/asia-east2/LeaveNote'),
      body: jsonEncode({
        'note': text,
        'liked_user_uid': liked_user_uid,
        'uid': uid,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) print("Note added");
  }

  Future<void> get_notes() async {
    final response = await http.post(
      //production url
      // Uri.parse(
      //     'https://asia-east2-qaabl-mobile-dev.cloudfunctions.net/GetNotes'),
      //testing url
      Uri.parse('http://127.0.0.1:5003/qaabl-mobile-dev/asia-east2/GetNotes'),
      body: jsonEncode({
        'uid': uid,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body);
      if (decodedResponse is List) {
        user_notes = decodedResponse.map<Map<String, dynamic>>((item) {
          return item as Map<String, dynamic>;
        }).toList();
      }
    } else {
      user_notes = null;
    }
  }

  //function to skip user without performing any action
  void skip_user(String skipped_user_uid) {
    user_Ids_in_queue.remove(skipped_user_uid);
    rebuildUi();
  }

  //function to display it's a match to the current user
  Future<http.Response> both_like_each_other(liked_user_uid) async {
    //show the its-a-match screen instantly, fast response
    _navigationService.navigateToItsAMatchView();
    //function that creates a match between the 2 users, server-side
    final response = await http.post(
      //production URL
      // Uri.parse(
      //     'https://asia-east2-qaabl-mobile-dev.cloudfunctions.net/CreateMatch'),
      //testing URL
      Uri.parse(
          'http://127.0.0.1:5003/qaabl-mobile-dev/asia-east2/CreateMatch'),
      body: jsonEncode({
        'user1_uid': uid,
        'user2_uid': liked_user_uid,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    _mixpanelService.mixpanel.track("Match Created");
    return response;
  }

  Future<http.Response> like_user_in_cloud(
      liked_user_uid, String like_or_super_like) async {
    //function that likes the other user
    final response = await http.post(
      //add the url of the function here
      //production URL
      // Uri.parse(
      //     'https://asia-east2-qaabl-mobile-dev.cloudfunctions.net/LikeUser'),
      //testing URL
      Uri.parse('http://127.0.0.1:5003/qaabl-mobile-dev/asia-east2/LikeUser'),
      body: jsonEncode({
        'user_uid': uid,
        'liked_user_uid': liked_user_uid,
        'like_or_super_like': like_or_super_like,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }

  Future<void> set_token_by_waiting_for_document() async {
    bool is_document_there = false;
    while (is_document_there != true) {
      await Future.delayed(Duration(seconds: 1));
      is_document_there = await _firestoreService.is_document_there(uid!);
    }
    _firestoreService.set_token(uid!);
  }

  void go_to_profile() {
    _navigationService.replaceWithProfileView();
  }

  void go_to_chats() {
    _navigationService.replaceWithChatsView();
  }

  void trackProfileViewEvent(String viewedID) {
    // Track the event with Mixpanel
    print('it went through');
    _mixpanelService.mixpanel.track('Profile Viewed', properties: {
      'viewedID': viewedID
      // Add other relevant properties here
    });
  }

  void trackHomePageVisit() {
    _mixpanelService.mixpanel.track('Visited home page');
  }

  Future signOut() async {
    final success = await _authenticationService.signOut();
    if (success) {
      _navigationService.replaceWithLoginView();
      _dialogService.showConfirmationDialog(
        title: "Successful",
        description: "Success.",
      );
    } else {
      _dialogService.showConfirmationDialog(
        title: "Unsuccessful",
        description: "Unsuccessful.",
      );
    }
  }

  String formatTimestamp(Map<String, dynamic> timestampMap) {
    if (timestampMap.containsKey('_seconds')) {
      var seconds = timestampMap['_seconds'];
      var nanoseconds = timestampMap['_nanoseconds'] ?? 0;
      var date = DateTime.fromMillisecondsSinceEpoch(seconds * 1000)
          .add(Duration(microseconds: nanoseconds ~/ 1000));
      return DateFormat('yyyy-MM-dd – HH:mm').format(date);
    } else {
      return 'Invalid Timestamp';
    }
  }
}
