import 'package:stacked/stacked.dart';
import 'package:stacked_app/app/app.locator.dart';
import 'package:stacked_app/app/app.router.dart';
import 'package:stacked_app/services/auth_service.dart';
//import 'package:stacked_app/ui/common/app_strings.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:collection';

class EditProfileViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();

  // current user id, defined class level to be reusable in all methods
  String? uid;

  //late because it will be initialized later in the code
  Map<String,dynamic> user_data = {};

  EditProfileViewModel() {
    // get the uid of the user
    uid = _authenticationService.currentUser?.uid;
    if (uid == null) {
      _navigationService.replaceWithLoginView();
    }

    //this data is the data that will populate all fields
    load_data();
  }

  //ToDo: function that gets the inputted values, updates the user document, and navigates back to profile page
  Future<http.Response> save_and_back(String name, List<Map <String, String>> interests) async{
    //get the values from the input fields and go update the values in the cloud
    //call the function
    final response = await http.post(
      //production url
      //Uri.parse(''),
      //testing url
      Uri.parse(
          'http://127.0.0.1:5002/qaabl-mobile-dev/asia-east2/UpdateProfileData'),
      body: jsonEncode({
        'uid': uid,
        'name': name,
        'interests': interests,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    back_to_profile(response);

    return response;
  }

  void back_to_profile(response) async{
    if (response.statusCode == 200) {
    // Show a green check mark or something that shows success of updating
    await _dialogService.showDialog(
      title: 'Success',
      description: 'Profile updated successfully.',
    );
    _navigationService.back();
  } else {
    // Handle error
    await _dialogService.showDialog(
      title: 'Error',
      description: 'Failed to update profile.',
    );
  }
  }

  Future<void> load_data() async {
    try {
      user_data = await get_needed_data();
      //ToDo: function that gets the profile picture
      notifyListeners();
    } catch (e) {
      print("couldn't fetch the percentage");
    }
  }

  //function that gets the necessary fields to populate a user's profile
  Future<Map<String,dynamic>> get_needed_data() async{
    //the needed data is: name, interests
    //we will also bring avatar/profile picture later

    //call the function from the cloud
    final response = await http.post(
      //production url
      //Uri.parse(''),
      //testing url
      Uri.parse(
          'http://127.0.0.1:5002/qaabl-mobile-dev/asia-east2/GetProfileData'),
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

}
