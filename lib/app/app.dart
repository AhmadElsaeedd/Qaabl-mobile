import 'package:qaabl_mobile/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:qaabl_mobile/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:qaabl_mobile/ui/views/home/home_view.dart';
import 'package:qaabl_mobile/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:qaabl_mobile/ui/views/login/login_view.dart';
import 'package:qaabl_mobile/services/auth_service.dart';
import 'package:qaabl_mobile/ui/views/register/register_view.dart';
import 'package:qaabl_mobile/ui/views/its_a_match/its_a_match_view.dart';
import 'package:qaabl_mobile/ui/views/profile/profile_view.dart';
import 'package:qaabl_mobile/ui/views/settings/settings_view.dart';
import 'package:qaabl_mobile/ui/views/edit_profile/edit_profile_view.dart';
import 'package:qaabl_mobile/ui/views/chats/chats_view.dart';
import 'package:qaabl_mobile/ui/views/in_chat/in_chat_view.dart';
import 'package:qaabl_mobile/services/firestore_service.dart';
import 'package:qaabl_mobile/services/messaging_service.dart';
import 'package:qaabl_mobile/services/mixpanel_service.dart';
import 'package:qaabl_mobile/ui/views/onboarding/onboarding_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: RegisterView),
    MaterialRoute(page: ItsAMatchView),
    MaterialRoute(page: ProfileView),
    MaterialRoute(page: SettingsView),
    MaterialRoute(page: EditProfileView),
    MaterialRoute(page: ChatsView),
    MaterialRoute(page: InChatView),
    MaterialRoute(page: OnboardingView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: AuthenticationService),
    LazySingleton(classType: FirestoreService),
    LazySingleton(classType: MessagingService),
    LazySingleton(classType: MixpanelService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
