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

  //initialized empty because it will be initialized later in the code
  Map<String, dynamic> user_data = {};

  EditProfileViewModel() {
    // get the uid of the user
    uid = _authenticationService.currentUser?.uid;
    if (uid == null) {
      _navigationService.replaceWithLoginView();
    }
    //this data is the data that will populate all fields
    load_data();
  }

  //function that gets the inputted values, updates the user document, and navigates back to profile page
  Future<void> save_and_back(
      String name, List<Map<String, String>> interests, int image_index) async {
    //get the values from the input fields and go update the values in the cloud
    final response = await http.post(
      //production url
      Uri.parse(
          'https://asia-east2-qaabl-mobile-dev.cloudfunctions.net/UpdateProfileData'),
      //testing url
      // Uri.parse(
      //     'http://127.0.0.1:5003/qaabl-mobile-dev/asia-east2/UpdateProfileData'),
      body: jsonEncode({
        'uid': uid,
        'name': name,
        'interests': interests,
        'image_index': image_index,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    back_to_profile(response);
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

  void back_to_profile(response) async {
    if (response.statusCode == 200) {
      //navigate back and show success
      _navigationService.replaceWithProfileView();
      await _dialogService.showDialog(
        title: 'Success',
        description: 'Profile updated successfully.',
      );
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
      if (user_data['interests'] == true) user_data['interests'] = [];
      print("user data fetched from database" + user_data.toString());
      rebuildUi();
    } catch (e) {
      print("couldn't fetch the percentage");
    }
  }

  //function that gets the necessary fields to populate a user's profile
  Future<Map<String, dynamic>> get_needed_data() async {
    //call the function from the cloud
    final response = await http.post(
      //production url
      Uri.parse(
          'https://asia-east2-qaabl-mobile-dev.cloudfunctions.net/GetProfileData'),
      //testing url
      // Uri.parse(
      //     'http://127.0.0.1:5003/qaabl-mobile-dev/asia-east2/GetProfileData'),
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

  //predefined interests to show users:
  final List<String> predefined_interests = [
    // 'Performing & Visual Arts 🎭🎨',
    // 'Sports & Fitness 🏋️‍♂️',
    // 'Outdoor & Adventure 🚴🧗‍♀️',
    // 'Arts & Crafts 🎨🧶',
    // 'STEM & Academics 🔬📖',
    // 'Games & Leisure ♟️🎲',
    // 'Music & Instruments 🎵🎤',
    // 'Tech & Gaming 💻🕹️',
    // 'Fashion & Personal Care 👠💄',
    // 'Travel & Nature 🌍⛺',
    // 'Culinary Arts & Food 🍳🍽️',
    // 'Business & Entrepreneurship 💼💸',
    // 'Wellness & Spirituality 🧘‍♀️🌅',
    // 'Cars & Motors 🚗🔧',
    // 'Communication & Social Media 💬📱',
    // 'Linguistics & Literature 🗣️📚',
    // 'Pets & Nature 🐕🍃',
    // 'Collectibles & Lifestyle 🛍️👟',
    // 'Strategy & Intellectual Pursuits 🧠♟️',
    // 'DIY & Home Activities 🧱🔨',
    'Performing and Visual Arts',
    'Sports and Fitness',
    'Outdoor and Adventure',
    'Arts and Crafts',
    'STEM and Academics',
    'Games and Leisure',
    'Music and Instruments',
    'Tech and Gaming',
    'Fashion and Personal Care',
    'Travel and Nature',
    'Culinary Arts and Food',
    'Business and Entrepreneurship',
    'Wellness and Spirituality',
    'Cars and Motors',
    'Communication and Social Media',
    'Linguistics and Literature',
    'Pets and Nature',
    'Collectibles and Lifestyle',
    'Strategy and Intellectual Pursuits',
    'DIY and Home Activities',
  ];

  void toggleInterestSelection(String interest) {
    print("User name is: " + user_data['name'].toString());
    if (user_data['interests'].any((map) => map['name'] == interest)) {
      // Find and remove the map that has 'interest' in the name field
      user_data['interests'].removeWhere((map) => map['name'] == interest);
      if (user_data['interests'] == true) user_data['interests'] = [];
    } else if (user_data['interests'].length < 7) {
      Map<String, String> interestMap = {'name': interest, 'description': ''};
      user_data['interests'].add(interestMap);
    }
    rebuildUi(); // Notify the view to rebuild
  }

  void update_name(String name) {
    user_data['name'] = name;
  }

  void update_interest_description(String interest, String description) {
    for (Map<String, dynamic> interestMap in user_data['interests']) {
      if (interestMap['name'] == interest) {
        interestMap['description'] = description;
        break;
      }
    }
  }
}
