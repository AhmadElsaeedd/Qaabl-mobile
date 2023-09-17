import 'package:stacked/stacked.dart';
import 'package:stacked_app/app/app.locator.dart';
import 'package:stacked_app/app/app.router.dart';
import 'package:stacked_app/services/auth_service.dart';
import 'package:stacked_services/stacked_services.dart';

class RegisterViewModel extends BaseViewModel {
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

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

  Future createUserWithEmailAndPassword(String email, String password) async{
    //call the function
    final success = await _authenticationService.createUserWithEmailAndPassword(
        email, password);

    //check whether success or failure
    if (success) {
      _navigationService.replaceWithHomeView();
    } else {
      //error logging in
      _dialogService.showDialog(
        title: 'Login Failure',
        description: 'Failed to create user with email and password.',
      );
    }
  }

  void navigateToLogin(){
    _navigationService.replaceWithLoginView();
  }
}
