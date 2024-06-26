import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:qaabl_mobile/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:qaabl_mobile/services/auth_service.dart';
import 'package:qaabl_mobile/services/firestore_service.dart';
import 'package:qaabl_mobile/services/messaging_service.dart';
import 'package:qaabl_mobile/services/mixpanel_service.dart';
import 'package:qaabl_mobile/services/photo_room_service.dart';
import 'package:qaabl_mobile/services/profanity_filter_service.dart';
// @stacked-import

import 'test_helpers.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<NavigationService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<BottomSheetService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<DialogService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<AuthenticationService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<FirestoreService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<MessagingService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<MixpanelService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<AvatarService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<PhotoRoomService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<ProfanityFilterService>(onMissingStub: OnMissingStub.returnDefault),
// @stacked-mock-spec
])
void registerServices() {
  getAndRegisterNavigationService();
  getAndRegisterBottomSheetService();
  getAndRegisterDialogService();
  getAndRegisterAuthenticationService();
  getAndRegisterFirestoreService();
  getAndRegisterMessagingService();
  getAndRegisterMixpanelService();
  getAndRegisterAvatarService();
  getAndRegisterPhotoRoomService();
  getAndRegisterProfanityFilterService();
// @stacked-mock-register
}

MockNavigationService getAndRegisterNavigationService() {
  _removeRegistrationIfExists<NavigationService>();
  final service = MockNavigationService();
  locator.registerSingleton<NavigationService>(service);
  return service;
}

MockBottomSheetService getAndRegisterBottomSheetService<T>({
  SheetResponse<T>? showCustomSheetResponse,
}) {
  _removeRegistrationIfExists<BottomSheetService>();
  final service = MockBottomSheetService();

  when(service.showCustomSheet<T, T>(
    enableDrag: anyNamed('enableDrag'),
    enterBottomSheetDuration: anyNamed('enterBottomSheetDuration'),
    exitBottomSheetDuration: anyNamed('exitBottomSheetDuration'),
    ignoreSafeArea: anyNamed('ignoreSafeArea'),
    isScrollControlled: anyNamed('isScrollControlled'),
    barrierDismissible: anyNamed('barrierDismissible'),
    additionalButtonTitle: anyNamed('additionalButtonTitle'),
    variant: anyNamed('variant'),
    title: anyNamed('title'),
    hasImage: anyNamed('hasImage'),
    imageUrl: anyNamed('imageUrl'),
    showIconInMainButton: anyNamed('showIconInMainButton'),
    mainButtonTitle: anyNamed('mainButtonTitle'),
    showIconInSecondaryButton: anyNamed('showIconInSecondaryButton'),
    secondaryButtonTitle: anyNamed('secondaryButtonTitle'),
    showIconInAdditionalButton: anyNamed('showIconInAdditionalButton'),
    takesInput: anyNamed('takesInput'),
    barrierColor: anyNamed('barrierColor'),
    barrierLabel: anyNamed('barrierLabel'),
    customData: anyNamed('customData'),
    data: anyNamed('data'),
    description: anyNamed('description'),
  )).thenAnswer((realInvocation) =>
      Future.value(showCustomSheetResponse ?? SheetResponse<T>()));

  locator.registerSingleton<BottomSheetService>(service);
  return service;
}

MockDialogService getAndRegisterDialogService() {
  _removeRegistrationIfExists<DialogService>();
  final service = MockDialogService();
  locator.registerSingleton<DialogService>(service);
  return service;
}

MockAuthenticationService getAndRegisterAuthenticationService() {
  _removeRegistrationIfExists<AuthenticationService>();
  final service = MockAuthenticationService();
  locator.registerSingleton<AuthenticationService>(service);
  return service;
}

MockFirestoreService getAndRegisterFirestoreService() {
  _removeRegistrationIfExists<FirestoreService>();
  final service = MockFirestoreService();
  locator.registerSingleton<FirestoreService>(service);
  return service;
}

MockMessagingService getAndRegisterMessagingService() {
  _removeRegistrationIfExists<MessagingService>();
  final service = MockMessagingService();
  locator.registerSingleton<MessagingService>(service);
  return service;
}

MockMixpanelService getAndRegisterMixpanelService() {
  _removeRegistrationIfExists<MixpanelService>();
  final service = MockMixpanelService();
  locator.registerSingleton<MixpanelService>(service);
  return service;
}

MockPhotoRoomService getAndRegisterPhotoRoomService() {
  _removeRegistrationIfExists<PhotoRoomService>();
  final service = MockPhotoRoomService();
  locator.registerSingleton<PhotoRoomService>(service);
  return service;
}

MockProfanityFilterService getAndRegisterProfanityFilterService() {
  _removeRegistrationIfExists<ProfanityFilterService>();
  final service = MockProfanityFilterService();
  locator.registerSingleton<ProfanityFilterService>(service);
  return service;
}
// @stacked-mock-create

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
