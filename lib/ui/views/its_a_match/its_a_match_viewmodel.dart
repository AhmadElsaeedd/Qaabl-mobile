import 'package:stacked/stacked.dart';
import 'package:qaabl_mobile/app/app.locator.dart';
import 'package:qaabl_mobile/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:qaabl_mobile/services/auth_service.dart';

class ItsAMatchViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authenticationService = locator<AuthenticationService>();

  // current user id, defined class level to be reusable in all methods
  String? uid;

  String? current_page;

  ItsAMatchViewModel() {
    uid = _authenticationService.currentUser?.uid;
    if (uid == null) {
      _navigationService.replaceWithLoginView();
    }
    current_page = "match";
  }

  void go_to_chats() {
    //go directly to chats, replace the its-a-match page with the chats page
    //supposed to be replaceWithChatsView though
    _navigationService.replaceWithChatsView();
  }

  void go_to_swiping() {
    //trying this method of navigation
    //should go back to previous route in the navigation stack (which is supposedly the home page)
    _navigationService.back();
  }

  void go_to_profile() {
    _navigationService.replaceWithProfileView();
  }

  void go_to_home() {
    _navigationService.replaceWithHomeView();
  }
}
