// ignore_for_file: non_constant_identifier_names

import 'package:stacked_app/app/app.bottomsheets.dart';
import 'package:stacked_app/app/app.dialogs.dart';
import 'package:stacked_app/app/app.locator.dart';
import 'package:stacked_app/app/app.router.dart';
import 'package:stacked_app/services/auth_service.dart';
import 'package:stacked_app/ui/common/app_strings.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:collection';

class HomeViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();

  // current user id, defined class level to be reusable in all methods
  String? uid;

  // constructor that calls the functions that need to get called when the page is loaded
  HomeViewModel() {
    // get the uid of the user
    uid = _authenticationService.currentUser?.uid;
    if (uid == null){
      _navigationService.replaceWithLoginView();
    }
    //getUsers();
  }

  String get counterLabel => 'Counter is: $_counter';

  int _counter = 0;

  void incrementCounter() {
    _counter++;
    rebuildUi();
  }

  void showDialog() {
    _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: 'Stacked Rocks!',
      description: 'Give stacked $_counter stars on Github',
    );
  }

  void showBottomSheet() {
    _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.notice,
      title: ksHomeBottomSheetTitle,
      description: ksHomeBottomSheetDescription,
    );
  }

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

  //ToDo: define a data structure that will hold the users, should be fast in deletion
  Queue<Map<String, dynamic>> users_queue = Queue();
  Set<String> user_Ids_in_queue = Set<String>();

  bool first_load = false;
  bool no_more_users = false;

  //A function that sends an HTTP request to a cloud function getUsers()
  //The function returns 3 users that are not in the likes, dislikes array of the user and not the user
  //We just need to pass the user object to the cloud function and the filtering will be done server-side
  Future<void> getUsers() async{
    try{
      //call the cloud function that gets 3 users, pass the uid to it
      print("length of users_queue "+users_queue.length.toString());
      if(users_queue.isEmpty){
        first_load = true;
      }
      final response = await http.post(
      //add the url of the function here
      //Uri.parse('https://asia-east2-qaabl-mobile-dev.cloudfunctions.net/GetUsers'),
      Uri.parse('http://127.0.0.1:5002/qaabl-mobile-dev/asia-east2/GetUsers'),
      body: jsonEncode({
        'uid': uid,
      }),
      headers: {'Content-Type': 'application/json'},
      );

      //response of the function should contain 3 users with their UIDs and interests
      if(response.statusCode!=200 && response.statusCode!=204) print("failed to go to cloud");
      else if(response.statusCode == 204){
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

      // Notify the UI to rebuild
      // notifyListeners();
      if(first_load == true) {
        rebuildUi();
        print("first load");
      }
      else print("not first load");

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
    print("length of users queue issss " + users_queue.length.toString());
    print("is this first load?" + first_load.toString());
    if(users_queue.length < 3 && first_load == false){
      getUsers();
    }
    if(users_queue.isNotEmpty){
      print("I am getting a new user");
      
      return users_queue.removeFirst();
    }
    return null;
  }

  //ToDo: function that likes a user, server-side
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
      //ToDo: remove user from queue
      user_Ids_in_queue.remove(liked_user_uid);
      print("I am done liking");
    }
    else print("failed to go to cloud");
    rebuildUi();
  }

  //ToDo: function that dislikes a user, server-side
}
