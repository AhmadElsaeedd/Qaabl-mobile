import 'package:stacked/stacked.dart';
import 'package:qaabl_mobile/app/app.locator.dart';
import 'package:qaabl_mobile/app/app.router.dart';
import 'package:qaabl_mobile/services/auth_service.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:qaabl_mobile/services/mixpanel_service.dart';

class LoginViewModel extends BaseViewModel {
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _mixpanelService = locator<MixpanelService>();

  Future signInWithGoogle() async {
    _mixpanelService.mixpanel.track('Login', properties: {
      'Method': 'Google',
    });
    final email = await _authenticationService.signInWithGoogle();
    if (email != null) {
      _navigationService.replaceWithHomeView();
      _mixpanelService.mixpanel.getPeople().set("Email", email);
    } else {
      //display error logging in using the dialog service
      _dialogService.showDialog(
        title: 'Login Failure',
        description: 'Failed to sign in with Google.',
      );
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    _mixpanelService.mixpanel.track('Login', properties: {
      'Method': 'Email and password',
    });
    //call the function
    final success = await _authenticationService.signInWithEmailAndPassword(
        email, password);

    //check whether success or failure
    if (success) {
      _navigationService.replaceWithHomeView();
      _mixpanelService.mixpanel.getPeople().set("Email", email);
    } else {
      //error logging in
      _dialogService.showDialog(
        title: 'Login Failure',
        description: 'Failed to sign in with email and password.',
      );
    }
  }

  Future signInWithApple() async {
    _mixpanelService.mixpanel.track('Login', properties: {
      'Method': 'Apple',
    });
    final email = await _authenticationService.signInWithApple();
    if (email != null) {
      _navigationService.replaceWithHomeView();
      _mixpanelService.mixpanel.getPeople().set("Email", email);
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
