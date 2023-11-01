// ignore_for_file: non_constant_identifier_names

//import 'package:stacked_app/app/app.bottomsheets.dart';
//import 'package:stacked_app/app/app.dialogs.dart';
import 'package:stacked_app/app/app.locator.dart';
import 'package:stacked_app/app/app.router.dart';
import 'package:stacked_app/services/auth_service.dart';
//import 'package:stacked_app/ui/common/app_strings.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:collection';
import 'package:stacked_app/services/firestore_service.dart';

class HomeViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final _firestoreService = locator<FirestoreService>();

  String? current_page;

  // current user id, defined class level to be reusable in all methods
  String? uid;

  //logic flags
  bool? first_load;
  bool? no_more_users;

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
  }

  // option to sign out (for testing purposes, will be removed from production)
  Future signOut() async {
    final success = await _authenticationService.signOut();
    if (success) {
      _navigationService.replaceWithLoginView();
      _dialogService.showConfirmationDialog(
        title: "Logout successful",
        description: "Successfully logged out of Qaabl.",
      );
    } else {
      _dialogService.showConfirmationDialog(
        title: "Logout unsuccessful",
        description: "Couldn't log out of Qaabl.",
      );
    }
  }

  void go_to_profile() {
    _navigationService.replaceWithProfileView();
  }

  void go_to_chats() {
    _navigationService.replaceWithChatsView();
  }

  //data structure that will hold the users info
  Queue<Map<String, dynamic>> users_queue = Queue();
  //list of users id's for easy access
  Set<String> user_Ids_in_queue = Set<String>();

  //A function that sends an HTTP request to a cloud function getUsers()
  Future<void> getUsers() async {
    try {
      // if (users_queue.isEmpty) {
      //   print("I am here in the first load");
      //   first_load = true;
      // }
      print("first load is: " + first_load.toString());
      print("Calling the cloud");

      final response = await http.post(
        //production url
        Uri.parse(
            'https://asia-east2-qaabl-mobile-dev.cloudfunctions.net/GetUsers'),
        //testing url
        // Uri.parse('http://127.0.0.1:5003/qaabl-mobile-dev/asia-east2/GetUsers'),
        body: jsonEncode({
          'uid': uid,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      print(
          "Cloud called with response code: " + response.statusCode.toString());

      //response of the function should contain 3 users with their UIDs and interests
      if (!(response.statusCode == 200 || response.statusCode == 204))
        print("failed to go to cloud");
      else if (response.statusCode == 204) {
        //tell the ui that there are no more users
        no_more_users = true;
        rebuildUi();
        return;
      }

      // Parse the JSON response and add it to the queue
      List<dynamic> users = jsonDecode(response.body);
      for (var user in users) {
        // if user already exists in queue, skip them
        String user_Id = user['id'];
        if (user_Ids_in_queue.contains(user_Id)) {
          print("skipping user");
          continue;
        }
        // add user to queue
        users_queue.add(user);
        user_Ids_in_queue.add(user_Id);
      }

      // Rebuild UI in first load only, because with first load the data is not there yet
      if (first_load == true) {
        rebuildUi();
        print("rebuilding");
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
    print("Get next user function call");
    print("Length of users queue: " + users_queue.length.toString());
    print("first load: " + first_load.toString());
    if ((no_more_users == true) ||
        (users_queue.length == 0 && first_load == false)) {
      no_more_users = true;
      return null;
    }
    //refill the queue when needed, we want to maintain having users in the queue
    if (users_queue.length < 2 || first_load == true) {
      getUsers();
    }
    //when queue has users, show the first user and banish them from existence
    if (users_queue.isNotEmpty) {
      return users_queue.removeFirst();
    }
  }

  //function that likes a user, server-side
  Future<void> like_user(String liked_user_uid, bool potential_match) async {
    //rebuild ui, meaning next user will be fetched
    rebuildUi();
    dynamic response;
    if (potential_match == true) {
      print("I am in the true place");
      //create a match between 2 users
      response = await both_like_each_other(liked_user_uid);
    } else {
      print("I am in the false place");
      //call the cloud function that likes a user
      response = await like_user_in_cloud(liked_user_uid);
    }

    //response of the function should contain true, that's it
    if (response.statusCode == 200) {
      //remove user from queue (already removed from the other queue when displaying)
      user_Ids_in_queue.remove(liked_user_uid);
      print("liked user successfully");
    } else if (response.statusCode == 204) {
      try {
        await both_like_each_other(liked_user_uid);
      } catch (e) {
        print("couldn't create a match: " + e.toString());
      }
    } else {
      print("failed to go to cloud");
    }

    // //rebuild ui, meaning next user will be fetched
    // rebuildUi();
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
      print("disliked user successfully");
    } else {
      print("failed to go to cloud");
    }

    // //rebuild ui, meaning next user will be fetched
    // rebuildUi();
  }

  //function to skip user without performing any action
  void skip_user(String skipped_user_uid) {
    user_Ids_in_queue.remove(skipped_user_uid);
    print("I am here");
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
      print("IN LOOP");
      await Future.delayed(Duration(seconds: 1));
      is_document_there = await _firestoreService.is_document_there(uid!);
    }
    _firestoreService.set_token(uid!);
  }
}
