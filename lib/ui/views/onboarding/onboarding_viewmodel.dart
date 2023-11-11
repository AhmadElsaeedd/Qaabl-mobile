import 'package:stacked/stacked.dart';
import 'package:qaabl_mobile/app/app.locator.dart';
import 'package:qaabl_mobile/app/app.router.dart';
import 'package:qaabl_mobile/services/auth_service.dart';
// import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

class OnboardingViewModel extends BaseViewModel {
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();

  // current user id, defined class level to be reusable in all methods
  String? uid;

  OnboardingViewModel() {
    // get the uid of the user
    uid = _authenticationService.currentUser?.uid;
    if (uid == null) {
      _navigationService.replaceWithLoginView();
    }
    //Maybe we could call the function that sets the fcm token here?
  }

  void go_to_home() {
    _navigationService.replaceWithHomeView();
  }
}
