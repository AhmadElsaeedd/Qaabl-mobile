// ignore_for_file: non_constant_identifier_names

//import 'package:stacked_app/app/app.bottomsheets.dart';
//import 'package:stacked_app/app/app.dialogs.dart';
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

  // Map<String, dynamic>? nextUser;

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
        Uri.parse(
            'https://asia-east2-qaabl-mobile-dev.cloudfunctions.net/GetUsers'),
        //testing url
        // Uri.parse('http://127.0.0.1:5003/qaabl-mobile-dev/asia-east2/GetUsers'),
        body: jsonEncode({
          'uid': uid,
          'users_queue_uids': user_Ids_in_queue.toList(),
        }),
        headers: {'Content-Type': 'application/json'},
      );
      print("Went to cloud with response code: " +
          response.statusCode.toString());
      //response of the function should contain 3 users with their UIDs and interests
      if (!(response.statusCode == 200 ||
          response.statusCode == 204 ||
          response.statusCode == 205))
        print("failed to go to cloud");
      else if (response.statusCode == 204) {
        // last_user = true;
        // rebuildUi();
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
            print("Adding user to queue");
            users_queue.add(user);
            user_Ids_in_queue.add(user_Id);
            seen_users.add(user_Id);
          }
        }
      }
      print("length of users queue: " + users_queue.length.toString());

      if (users_queue.isEmpty) {
        print("here");
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
      print("Down to last user");
      last_user = true;
      no_more_users = true;
      return users_queue.removeFirst();
    }
    print("Users queue length: " + users_queue.length.toString());
    //when the queue is empty after the first load or there is no more users or user shouldnt continue
    if ((no_more_users == true) ||
        (users_queue.length == 0 && first_load == false) ||
        (user_continues == false)) {
      print("Users queue length: " + users_queue.length.toString());
      print("No more users: " + no_more_users.toString());
      print("First load: " + first_load.toString());
      print("User continues: " + user_continues.toString());
      print("I am here");
      no_more_users == true;
      return null;
    }
    // //refill the queue when needed, we want to maintain having users in the queue
    if ((users_queue.length < 10 || first_load == true) &&
        (no_more_users == false) &&
        (last_user == false)) {
      print("I am here trying to get users");
      getUsers();
    }

    //when queue has users, show the first user and banish them from existence
    if (users_queue.isNotEmpty && user_continues == true) {
      print("I AM RETURNING A USER");
      return users_queue.removeFirst();
    }
    return null;
  }

  //function that likes a user, server-side
  Future<void> like_user(String liked_user_uid, bool potential_match) async {
    //rebuild ui, meaning next user will be fetched
    rebuildUi();
    dynamic response;
    if (potential_match == true) {
      //create a match between 2 users
      response = await both_like_each_other(liked_user_uid);
    } else {
      //call the cloud function that likes a user
      response = await like_user_in_cloud(liked_user_uid);
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
    //rebuild ui, meaning next user will be fetched
    rebuildUi();
    //call the cloud function that dislikes a user
    final response = await http.post(
      //add the url of the function here
      //production URL
      Uri.parse(
          'https://asia-east2-qaabl-mobile-dev.cloudfunctions.net/DislikeUser'),
      //testing URL
      // Uri.parse(
      //     'http://127.0.0.1:5003/qaabl-mobile-dev/asia-east2/DislikeUser'),
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
      Uri.parse(
          'https://asia-east2-qaabl-mobile-dev.cloudfunctions.net/CreateMatch'),
      //testing URL
      // Uri.parse(
      //     'http://127.0.0.1:5003/qaabl-mobile-dev/asia-east2/CreateMatch'),
      body: jsonEncode({
        'user1_uid': uid,
        'user2_uid': liked_user_uid,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    _mixpanelService.mixpanel.track("Match Created");
    return response;
  }

  Future<http.Response> like_user_in_cloud(liked_user_uid) async {
    //function that likes the other user
    final response = await http.post(
      //add the url of the function here
      //production URL
      Uri.parse(
          'https://asia-east2-qaabl-mobile-dev.cloudfunctions.net/LikeUser'),
      //testing URL
      // Uri.parse('http://127.0.0.1:5003/qaabl-mobile-dev/asia-east2/LikeUser'),
      body: jsonEncode({
        'user_uid': uid,
        'liked_user_uid': liked_user_uid,
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
}
