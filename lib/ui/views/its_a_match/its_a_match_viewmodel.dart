import 'package:stacked/stacked.dart';
import 'package:stacked_app/app/app.locator.dart';
import 'package:stacked_app/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class ItsAMatchViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

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
}
