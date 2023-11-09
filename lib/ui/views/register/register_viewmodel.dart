import 'package:stacked/stacked.dart';
import 'package:qaabl_mobile/app/app.locator.dart';
import 'package:qaabl_mobile/app/app.router.dart';
import 'package:qaabl_mobile/services/auth_service.dart';
import 'package:qaabl_mobile/services/mixpanel_service.dart';
import 'package:stacked_services/stacked_services.dart';

class RegisterViewModel extends BaseViewModel {
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _mixpanelService = locator<MixpanelService>();

  Future signInWithGoogle() async {
    try {
      _mixpanelService.mixpanel.track('Sign up', properties: {
        'Method': 'Google',
      });
      final result = await _authenticationService.signInWithGoogle();
      final email = result!['email'];
      final isNewUser = result['isNewUser'];
      _mixpanelService.mixpanel.getPeople().set("Email", email);
      if (!isNewUser) {
        _navigationService.replaceWithHomeView();
      } else {
        _navigationService.replaceWithOnboardingView();
      }
    } catch (e) {
      //display error logging in using the dialog service
      _dialogService.showDialog(
        title: 'Login Failure',
        description: 'Failed to sign in with Google.',
      );
    }
  }

  Future createUserWithEmailAndPassword(String email, String password) async {
    _mixpanelService.mixpanel.track('Sign up', properties: {
      'Method': 'Email and password',
    });
    //call the function
    final success = await _authenticationService.createUserWithEmailAndPassword(
        email, password);

    //check whether success or failure
    if (success) {
      _navigationService.replaceWithOnboardingView();
    } else {
      //error logging in
      _dialogService.showDialog(
        title: 'Login Failure',
        description: 'Failed to create user with email and password.',
      );
    }
  }

  Future signInWithApple() async {
    try {
      _mixpanelService.mixpanel.track('Sign up', properties: {
        'Method': 'Apple',
      });
      final result = await _authenticationService.signInWithApple();
      final email = result!['email'];
      final isNewUser = result['isNewUser'];
      _mixpanelService.mixpanel.getPeople().set("Email", email);
      if (!isNewUser) {
        _navigationService.replaceWithHomeView();
      } else {
        _navigationService.replaceWithOnboardingView();
      }
    } catch (e) {
      _dialogService.showDialog(
        title: 'Login Failure',
        description: 'Failed to sign in with Apple.',
      );
    }
  }

  void navigateToLogin() {
    _navigationService.replaceWithLoginView();
  }
}
