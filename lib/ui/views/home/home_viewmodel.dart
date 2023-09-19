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

class HomeViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  //final _bottomSheetService = locator<BottomSheetService>();
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();

  // current user id, defined class level to be reusable in all methods
  String? uid;

  // constructor runs whenever the page is loaded or reloaded
  HomeViewModel() {
    // get the uid of the user
    uid = _authenticationService.currentUser?.uid;
    if (uid == null){
      _navigationService.replaceWithLoginView();
    }
  }

  // option to sign out (for testing purposes, will be removed from production)
  Future signOut() async{
    final success = await _authenticationService.signOut();
    if(success){
      _navigationService.replaceWithLoginView();
      _dialogService.showConfirmationDialog(
        title:"Logout successful", 
        description:"Successfully logged out of Qaabl.",
      );
    }
    else{
      _dialogService.showConfirmationDialog(
        title:"Logout unsuccessful", 
        description:"Couldn't log out of Qaabl.",
      );
    }
  }

  // a data structure that will hold the users, should be fast in insertion/deletion
  Queue<Map<String, dynamic>> users_queue = Queue();
  // keeping list of users id's for easy access
  Set<String> user_Ids_in_queue = Set<String>();

  // logic flags
  bool first_load = false;
  bool no_more_users = false;

  //A function that sends an HTTP request to a cloud function getUsers()
  //The function returns 3 users that are not in the likes, dislikes, matches arrays of the user AND not the user
  //We just need to pass the user_uid to the cloud function and the filtering will be done server-side
  Future<void> getUsers() async{
    try{
      //call the cloud function that gets 3 users, pass the uid to it
      if(users_queue.isEmpty){
        // queue will never be empty as long as there are users left
        first_load = true;
      }

      final response = await http.post(
      //production url
      //Uri.parse('https://asia-east2-qaabl-mobile-dev.cloudfunctions.net/GetUsers'),
      //testing url
      Uri.parse('http://127.0.0.1:5002/qaabl-mobile-dev/asia-east2/GetUsers'),
      body: jsonEncode({
        'uid': uid,
      }),
      headers: {'Content-Type': 'application/json'},
      );

      //response of the function should contain 3 users with their UIDs and interests
      if(!(response.statusCode==200 || response.statusCode==204)) print("failed to go to cloud");
      else if(response.statusCode == 204){
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
        continue;
        }
        // add user to queue
        users_queue.add(user);
        user_Ids_in_queue.add(user_Id);
      }

      print("length of users_queue "+users_queue.length.toString());
      print("users queue:"+ users_queue.toString());

      // Rebuild UI in first load only, because with first load the data is not there yet
      if(first_load == true) {
        rebuildUi();
        print("first load");
      }
      else print("not first load");

      // Stop it from reloading infinitely
      first_load = false;
    }
    catch (e){
      // Handle exception
      _dialogService.showConfirmationDialog(
        title: "Exception",
        description: "An exception occurred: $e",
      );
    }
  }

  // function to get next user
  Map<String,dynamic>? get_next_user(){
    //refill the queue when needed, we want to maintain having users in the queue
    if(users_queue.length < 3 && first_load == false){
      getUsers();
    }

    //when queue has users, show the first user and banish them from existence
    if(users_queue.isNotEmpty){
      return users_queue.removeFirst();
    }

    return null;
  }

  //function that likes a user, server-side
  Future<void> like_user(String liked_user_uid) async{
    //call the cloud function that likes a user
    final response = await http.post(
      //add the url of the function here
      Uri.parse('http://127.0.0.1:5002/qaabl-mobile-dev/asia-east2/LikeUser'),
      body: jsonEncode({
        'user_uid': uid,
        'liked_user_uid': liked_user_uid,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    //response of the function should contain true, that's it
    if(response.statusCode == 200){
      //remove user from queue (already removed from the other queue when displaying)
      user_Ids_in_queue.remove(liked_user_uid);
    }
    else print("failed to go to cloud");

    //rebuild ui, meaning next user will be fetched
    rebuildUi();
  }

  //ToDo: function that dislikes a user, server-side
}
