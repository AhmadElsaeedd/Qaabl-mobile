import 'package:stacked/stacked.dart';
import 'package:stacked_app/app/app.locator.dart';
import 'package:stacked_app/app/app.router.dart';
import 'package:stacked_app/services/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SettingsViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  //final _bottomSheetService = locator<BottomSheetService>();
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();

  String? uid;

  SettingsViewModel() {
    // get the uid of the user
    uid = _authenticationService.currentUser?.uid;
    if (uid == null) {
      _navigationService.replaceWithLoginView();
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

  Future signOut() async {
    final success = await _authenticationService.signOut();
    if (success) {
      _navigationService.replaceWithLoginView();
      _dialogService.showConfirmationDialog(
        title: "Successful",
        description: "Successfully deleted account.",
      );
    } else {
      _dialogService.showConfirmationDialog(
        title: "Unsuccessful",
        description: "Couldn't delete account.",
      );
    }
  }

  Future<http.Response> delete_account(uid) async {
    //Call the function that deletes the account from the server
    final response = await http.post(
      //add the url of the function here
      //production URL
      Uri.parse(
          'https://asia-east2-qaabl-mobile-dev.cloudfunctions.net/DeleteAccount'),
      //testing URL
      // Uri.parse(
      //     'http://127.0.0.1:5003/qaabl-mobile-dev/asia-east2/DeleteAccount'),
      body: jsonEncode({
        'user_uid': uid,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }

  Future<void> edit_password_email() async {
    //the function to send an automatic email for password reset is a client-side function
    //write it in the authentication service
    _authenticationService.edit_password_email();
  }
}
