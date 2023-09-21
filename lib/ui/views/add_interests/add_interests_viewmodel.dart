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

class AddInterestsViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();

  // current user id, defined class level to be reusable in all methods
  String? uid;

  //waiting for those from the past view
  final List<dynamic> interests_names;
  final List<String> selected_interests;

  //predefined interests to show users:
  final List<String> predefined_interests = [
    'Football',
    'Cards',
    'Pet-training',
    'Skiing',
    'Reading',
    'Coffee',
    'Walking',
    'Basketball',
    'Shopping',
    'Fishing',
    'Rock climbing',
    'Diving',
  ];

  AddInterestsViewModel(this.interests_names) : selected_interests = List<String>.from(interests_names) {
    // get the uid of the user
    uid = _authenticationService.currentUser?.uid;
    if (uid == null) {
      _navigationService.replaceWithLoginView();
    }
  }

  void toggleInterestSelection(String interest) {
    if (selected_interests.contains(interest)) {
      selected_interests.remove(interest);
    } else if (selected_interests.length < 7) {
      selected_interests.add(interest);
    }
    notifyListeners(); // Notify the view to rebuild
  }

  Future<void> save_and_back(selected_interests) async {
    //get the values from the input fields and pass them back to the page
    print("Selected interests are: "+ selected_interests.toString());
    _navigationService.replaceWithEditProfileView(selectedinterests: selected_interests); 
  }

}

