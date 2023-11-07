import 'package:stacked/stacked.dart';
import 'package:qaabl_mobile/app/app.locator.dart';
import 'package:qaabl_mobile/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:qaabl_mobile/services/auth_service.dart';
import 'package:qaabl_mobile/services/messaging_service.dart';
import 'package:qaabl_mobile/services/mixpanel_service.dart';

class StartupViewModel extends BaseViewModel {
  //get the authentication and navigation service
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final _messagingService = locator<MessagingService>();
  final _mixpanelService = locator<MixpanelService>();

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    await Future.delayed(const Duration(seconds: 1));

    await _mixpanelService.initialize();

    await _messagingService.initialize();

    //check that the user is logged in
    if (_authenticationService.currentUser != null) {
      _navigationService.replaceWithHomeView();
      _mixpanelService.mixpanel
          .identify(_authenticationService.currentUser!.uid);
    } else {
      //if user is not logged in, go to login page
      _navigationService.replaceWithLoginView();
    }
  }
}
