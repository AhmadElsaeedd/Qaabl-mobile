import 'package:stacked/stacked.dart';
import 'package:stacked_app/app/app.locator.dart';
import 'package:stacked_app/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_app/services/auth_service.dart';
import 'package:stacked_app/services/messaging_service.dart';

class StartupViewModel extends BaseViewModel {
  //get the authentication and navigation service
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final _messagingService = locator<MessagingService>();

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    await Future.delayed(const Duration(seconds: 3));

    //check that the user is logged in
    if (_authenticationService.currentUser != null) {
      _navigationService.replaceWithHomeView();
    } else {
      //if user is not logged in, go to login page
      _navigationService.replaceWithLoginView();
    }
    //Ahmad committing
    // This is where you can make decisions on where your app should navigate when
    // you have custom startup logic
  }
}
