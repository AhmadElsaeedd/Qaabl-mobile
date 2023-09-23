import 'package:stacked_app/app/app.locator.dart';
import 'package:stacked_app/app/app.router.dart';
import 'package:stacked_app/services/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_app/services/firestore_service.dart';
import 'package:stacked_services/stacked_services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:collection';


class ChatsViewModel extends MultipleStreamViewModel {
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final _firestoreService = locator<FirestoreService>();

  // current user id, defined class level to be reusable in all methods
  String? uid;

  @override
  Map<String, Stream<List<Match>>> get streams {
    final uid = _authenticationService.currentUser?.uid;
    if (uid == null) {
      _navigationService.replaceWithLoginView();
      return {};
    }

    return {
      'new_chats': _firestoreService.get_new_matches(uid),
      'old_chats': _firestoreService.get_old_matches(uid),
    };
  }

}
