// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i14;
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_app/ui/views/add_interests/add_interests_view.dart'
    as _i11;
import 'package:stacked_app/ui/views/chats/chats_view.dart' as _i12;
import 'package:stacked_app/ui/views/counter/counter_view.dart' as _i4;
import 'package:stacked_app/ui/views/edit_profile/edit_profile_view.dart'
    as _i10;
import 'package:stacked_app/ui/views/home/home_view.dart' as _i2;
import 'package:stacked_app/ui/views/in_chat/in_chat_view.dart' as _i13;
import 'package:stacked_app/ui/views/its_a_match/its_a_match_view.dart' as _i7;
import 'package:stacked_app/ui/views/login/login_view.dart' as _i5;
import 'package:stacked_app/ui/views/profile/profile_view.dart' as _i8;
import 'package:stacked_app/ui/views/register/register_view.dart' as _i6;
import 'package:stacked_app/ui/views/settings/settings_view.dart' as _i9;
import 'package:stacked_app/ui/views/startup/startup_view.dart' as _i3;
import 'package:stacked_services/stacked_services.dart' as _i15;

class Routes {
  static const homeView = '/home-view';

  static const startupView = '/startup-view';

  static const counterView = '/counter-view';

  static const loginView = '/login-view';

  static const registerView = '/register-view';

  static const itsAMatchView = '/its-amatch-view';

  static const profileView = '/profile-view';

  static const settingsView = '/settings-view';

  static const editProfileView = '/edit-profile-view';

  static const addInterestsView = '/add-interests-view';

  static const chatsView = '/chats-view';

  static const inChatView = '/in-chat-view';

  static const all = <String>{
    homeView,
    startupView,
    counterView,
    loginView,
    registerView,
    itsAMatchView,
    profileView,
    settingsView,
    editProfileView,
    addInterestsView,
    chatsView,
    inChatView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.homeView,
      page: _i2.HomeView,
    ),
    _i1.RouteDef(
      Routes.startupView,
      page: _i3.StartupView,
    ),
    _i1.RouteDef(
      Routes.counterView,
      page: _i4.CounterView,
    ),
    _i1.RouteDef(
      Routes.loginView,
      page: _i5.LoginView,
    ),
    _i1.RouteDef(
      Routes.registerView,
      page: _i6.RegisterView,
    ),
    _i1.RouteDef(
      Routes.itsAMatchView,
      page: _i7.ItsAMatchView,
    ),
    _i1.RouteDef(
      Routes.profileView,
      page: _i8.ProfileView,
    ),
    _i1.RouteDef(
      Routes.settingsView,
      page: _i9.SettingsView,
    ),
    _i1.RouteDef(
      Routes.editProfileView,
      page: _i10.EditProfileView,
    ),
    _i1.RouteDef(
      Routes.addInterestsView,
      page: _i11.AddInterestsView,
    ),
    _i1.RouteDef(
      Routes.chatsView,
      page: _i12.ChatsView,
    ),
    _i1.RouteDef(
      Routes.inChatView,
      page: _i13.InChatView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.HomeView: (data) {
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.HomeView(),
        settings: data,
      );
    },
    _i3.StartupView: (data) {
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) => const _i3.StartupView(),
        settings: data,
      );
    },
    _i4.CounterView: (data) {
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) => const _i4.CounterView(),
        settings: data,
      );
    },
    _i5.LoginView: (data) {
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) => const _i5.LoginView(),
        settings: data,
      );
    },
    _i6.RegisterView: (data) {
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) => const _i6.RegisterView(),
        settings: data,
      );
    },
    _i7.ItsAMatchView: (data) {
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) => const _i7.ItsAMatchView(),
        settings: data,
      );
    },
    _i8.ProfileView: (data) {
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) => const _i8.ProfileView(),
        settings: data,
      );
    },
    _i9.SettingsView: (data) {
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) => const _i9.SettingsView(),
        settings: data,
      );
    },
    _i10.EditProfileView: (data) {
      final args = data.getArgs<EditProfileViewArguments>(
        orElse: () => const EditProfileViewArguments(),
      );
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) => _i10.EditProfileView(
            key: args.key, selected_interests: args.selectedinterests),
        settings: data,
      );
    },
    _i11.AddInterestsView: (data) {
      final args = data.getArgs<AddInterestsViewArguments>(nullOk: false);
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) => _i11.AddInterestsView(
            key: args.key, interests_names: args.interestsnames),
        settings: data,
      );
    },
    _i12.ChatsView: (data) {
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) => const _i12.ChatsView(),
        settings: data,
      );
    },
    _i13.InChatView: (data) {
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) => const _i13.InChatView(),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;
  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class EditProfileViewArguments {
  const EditProfileViewArguments({
    this.key,
    this.selectedinterests,
  });

  final _i14.Key? key;

  final List<String>? selectedinterests;

  @override
  String toString() {
    return '{"key": "$key", "selectedinterests": "$selectedinterests"}';
  }

  @override
  bool operator ==(covariant EditProfileViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.selectedinterests == selectedinterests;
  }

  @override
  int get hashCode {
    return key.hashCode ^ selectedinterests.hashCode;
  }
}

class AddInterestsViewArguments {
  const AddInterestsViewArguments({
    this.key,
    required this.interestsnames,
  });

  final _i14.Key? key;

  final List<dynamic> interestsnames;

  @override
  String toString() {
    return '{"key": "$key", "interestsnames": "$interestsnames"}';
  }

  @override
  bool operator ==(covariant AddInterestsViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.interestsnames == interestsnames;
  }

  @override
  int get hashCode {
    return key.hashCode ^ interestsnames.hashCode;
  }
}

extension NavigatorStateExtension on _i15.NavigationService {
  Future<dynamic> navigateToHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCounterView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.counterView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToLoginView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.loginView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToRegisterView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.registerView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToItsAMatchView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.itsAMatchView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToProfileView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.profileView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSettingsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.settingsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToEditProfileView({
    _i14.Key? key,
    List<String>? selectedinterests,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.editProfileView,
        arguments: EditProfileViewArguments(
            key: key, selectedinterests: selectedinterests),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAddInterestsView({
    _i14.Key? key,
    required List<dynamic> interestsnames,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.addInterestsView,
        arguments:
            AddInterestsViewArguments(key: key, interestsnames: interestsnames),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToChatsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.chatsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToInChatView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.inChatView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCounterView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.counterView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithLoginView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.loginView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithRegisterView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.registerView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithItsAMatchView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.itsAMatchView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithProfileView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.profileView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSettingsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.settingsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithEditProfileView({
    _i14.Key? key,
    List<String>? selectedinterests,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.editProfileView,
        arguments: EditProfileViewArguments(
            key: key, selectedinterests: selectedinterests),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAddInterestsView({
    _i14.Key? key,
    required List<dynamic> interestsnames,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.addInterestsView,
        arguments:
            AddInterestsViewArguments(key: key, interestsnames: interestsnames),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithChatsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.chatsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithInChatView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.inChatView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
