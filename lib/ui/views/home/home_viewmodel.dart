import 'package:stacked_app/app/app.bottomsheets.dart';
import 'package:stacked_app/app/app.dialogs.dart';
import 'package:stacked_app/app/app.locator.dart';
import 'package:stacked_app/app/app.router.dart';
import 'package:stacked_app/services/auth_service.dart';
import 'package:stacked_app/ui/common/app_strings.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'dart:convert';

class HomeViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();

  String get counterLabel => 'Counter is: $_counter';

  int _counter = 0;

  void incrementCounter() {
    _counter++;
    rebuildUi();
  }

  void showDialog() {
    _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: 'Stacked Rocks!',
      description: 'Give stacked $_counter stars on Github',
    );
  }

  void showBottomSheet() {
    _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.notice,
      title: ksHomeBottomSheetTitle,
      description: ksHomeBottomSheetDescription,
    );
  }

  Future signOut() async{
    final success = await _authenticationService.signOut();
    if(success){
      _navigationService.replaceWithLoginView();
      _dialogService.showConfirmationDialog(
        title:"Logout successful", 
        description:"Successfully logged out of Qaabl.",
      );
    }
    else{
      _dialogService.showConfirmationDialog(
        title:"Logout unsuccessful", 
        description:"Couldn't log out of Qaabl.",
      );
    }
  }

  //ToDo: define a data structure that will hold the users, should be fast in deletion

  //ToDo: a function that sends an HTTP request to a cloud function getUsers()
  //The function returns 3 users that are not in the likes, dislikes array of the user and not the user
  //We just need to pass the user object to the cloud function and the filtering will be done server-side
  Future<void> getUsers() async{
    try{
      // get the uid of the user
      String? uid = _authenticationService.currentUser?.uid;
      if (uid == null){
        _navigationService.replaceWithLoginView();
      }
      else{
        print("user is logged in:"+ uid);
      }
      //get the likes array of the user

      //get the dislikes array of the user

      //call the cloud function that gets 5 users, pass the likes, dislikes, uid to it

      //response of the function should contain 5 users with their UIDs and interests

    }
    catch (e){
      // Handle exception
      _dialogService.showConfirmationDialog(
        title: "Exception",
        description: "An exception occurred: $e",
      );
    }
  }
}
