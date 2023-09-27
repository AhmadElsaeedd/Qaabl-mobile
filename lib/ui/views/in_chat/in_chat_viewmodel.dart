import 'package:stacked/stacked.dart';
import 'package:stacked_app/app/app.locator.dart';
import 'package:stacked_app/app/app.router.dart';
import 'package:stacked_app/services/auth_service.dart';
import 'package:stacked_app/services/firestore_service.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_app/models/message_model.dart';

class InChatViewModel extends StreamViewModel {
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final _firestoreService = locator<FirestoreService>();

  String? uid;

  //declare the matchID
  final String match_id;

  //declare the name of the other user in chat
  final String user_name;


  //the constructor needs to know which chat it is going to
  InChatViewModel(this.match_id, this.user_name);

  //ToDo: implement the stream getter, that listens to messages in the chat
  @override
  Stream<List<Message>> get stream {
    uid = _authenticationService.currentUser?.uid;
    if (uid == null) {
      _navigationService.replaceWithLoginView();
      return Stream.value([]);
    }
    return _firestoreService.load_messages(match_id);
  }

  //ToDo: implement function that adds a message to the chat
  void send_message(String content){
    _firestoreService.send_message(match_id, content, uid!);
  }
}
