import 'package:flutter_test/flutter_test.dart';
import 'package:qaabl_mobile/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('AuthenticationServiceTest -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
