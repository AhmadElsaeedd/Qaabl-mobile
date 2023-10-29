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

class ProfileViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();

  // current user id, defined class level to be reusable in all methods
  String? uid;

  //percentage to be passed to the view
  int? percentage;

  int? image_index;

  ProfileViewModel() {
    // get the uid of the user
    uid = _authenticationService.currentUser?.uid;
    if (uid == null) {
      _navigationService.replaceWithLoginView();
    }

    load_data();
  }

  void go_to_settings() {
    //navigate to because it adds it on top in the navigation stack
    //then from the settings page, we can go back to this page by using the back method
    _navigationService.navigateToSettingsView();
  }

  void go_to_edit_profile() {
    _navigationService.navigateToEditProfileView();
  }

  Future<void> load_data() async {
    try {
      final results = await Future.wait([
        get_percentage(),
        get_profile_pic_index(),
      ]);

      percentage = results[0];
      image_index = results[1];

      rebuildUi();
    } catch (e) {
      print("couldn't fetch the percentage: " + e.toString());
    }
  }

  //function to return how complete the profile is
  Future<int> get_percentage() async {
    //call function that gets how full the profile is
    final response = await http.post(
      //production url
      Uri.parse(
          'https://asia-east2-qaabl-mobile-dev.cloudfunctions.net/GetProfilePercentage'),
      //testing url
      // Uri.parse(
      //     'http://127.0.0.1:5003/qaabl-mobile-dev/asia-east2/GetProfilePercentage'),
      body: jsonEncode({
        'uid': uid,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse['percentage'] as int;
    } else {
      // If the server returns an error, throw an exception
      throw Exception('Failed to get percentage');
    }
  }

  //ToDo: function to get the profile picture of the user
  Future<int> get_profile_pic_index() async {
    final response = await http.post(
      //production url
      Uri.parse(
          'https://asia-east2-qaabl-mobile-dev.cloudfunctions.net/GetProfilePercentage'),
      //testing url
      // Uri.parse(
      //     'http://127.0.0.1:5003/qaabl-mobile-dev/asia-east2/GetImageIndex'),
      body: jsonEncode({
        'uid': uid,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse['image_index'] as int;
    } else {
      // If the server returns an error, throw an exception
      throw Exception('Failed to get image_index');
    }
  }

  void go_to_profile() {
    _navigationService.replaceWithProfileView();
  }

  void go_to_chats() {
    _navigationService.replaceWithChatsView();
  }

  void go_to_home() {
    _navigationService.replaceWithHomeView();
  }
}
