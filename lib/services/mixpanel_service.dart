import 'package:injectable/injectable.dart';
import 'package:stacked_app/app/app.locator.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

@lazySingleton
class MixpanelService {
  late Mixpanel _mixpanel;

  Future<void> initialize() async {
    print("mixpanel initialization started");
    _mixpanel = await Mixpanel.init("ba055e34e50a5e2e87a1664fa7e5e7de",
        trackAutomaticEvents: true);
    print("mixpanel initialized");
  }

  Mixpanel get mixpanel => _mixpanel;
}
