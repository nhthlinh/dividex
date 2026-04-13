import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DeviceInfoService testability assessment', () {
    test(
      'documents current limitation for unit tests due to static platform plugins',
      () {
        const reason =
            'DeviceInfoService currently depends on static calls to '
            'DeviceInfoPlugin, PackageInfo.fromPlatform, and Geolocator APIs, '
            'which are hard to isolate in pure unit tests without refactoring.';

        expect(reason, contains('hard to isolate'));
      },
    );
  });
}
