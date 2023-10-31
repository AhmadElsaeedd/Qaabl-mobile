import 'package:stacked/stacked.dart';
import 'package:stacked_app/app/app.locator.dart';
import 'package:stacked_app/app/app.router.dart';
import 'package:stacked_app/services/auth_service.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_app/services/mixpanel_service.dart';

class LoginViewModel extends BaseViewModel {
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _mixpanelService = locator<MixpanelService>();

  Future signInWithGoogle() async {
    final success = await _authenticationService.signInWithGoogle();
    if (success) {
      _navigationService.replaceWithHomeView();
    } else {
      //display error logging in using the dialog service
      _dialogService.showDialog(
        title: 'Login Failure',
        description: 'Failed to sign in with Google.',
      );
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    //call the function
    final success = await _authenticationService.signInWithEmailAndPassword(
        email, password);

    //check whether success or failure
    if (success) {
      _navigationService.replaceWithHomeView();
    } else {
      //error logging in
      _dialogService.showDialog(
        title: 'Login Failure',
        description: 'Failed to sign in with email and password.',
      );
    }
  }

  Future signInWithApple() async {
    final success = await _authenticationService.signInWithApple();
    if (success) {
      _navigationService.replaceWithHomeView();
    } else {
      _dialogService.showDialog(
        title: 'Login Failure',
        description: 'Failed to sign in with Apple.',
      );
    }
  }

  void navigateToRegister() {
    _navigationService.replaceWithRegisterView();
  }
}
