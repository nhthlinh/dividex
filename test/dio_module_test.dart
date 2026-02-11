import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';

void main() {
  final getIt = GetIt.instance;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    dotenv.testLoad(fileInput: 'BASE_URL=https://api.test.com');

    HiveService.enableTestMode(locale: 'vi');
    HiveService.mockToken(
      accessToken: 'access123',
      refreshToken: 'refresh123',
    );

    await configureDependencies();
    await getIt.allReady();
  });


  tearDownAll(() async {
    await getIt.reset();
  });

  test('Dio is created with correct base options', () async {
    final dio = await getIt.getAsync<Dio>();

    expect(dio.options.baseUrl, 'https://api.test.com');
    expect(dio.options.connectTimeout, const Duration(seconds: 10));
    expect(dio.interceptors.isNotEmpty, true);
  });

  test('Authorization header is added from HiveService token', () async {
    final dio = await getIt.getAsync<Dio>();

    late RequestOptions captured;

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          captured = options;
          handler.resolve(
            Response(requestOptions: options, data: {}),
          );
        },
      ),
    );

    await dio.get('/test');

    expect(
      captured.headers['Authorization'],
      'Bearer access123',
    );
  });

  test('Throw exception if BASE_URL missing', () async {
    dotenv.testLoad(fileInput: '');

    await getIt.reset();

    await configureDependencies();

    expect(
      () async => await getIt.getAsync<Dio>(),
      throwsA(isA<Exception>()),
    );
  });
}
