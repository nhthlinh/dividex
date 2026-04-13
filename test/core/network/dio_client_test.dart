import 'package:dio/dio.dart';
import 'package:Dividex/core/network/dio_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('apiCallWrapper', () {
    test('returns value when api call succeeds', () async {
      final result = await apiCallWrapper<String>(() async => 'ok');

      expect(result, 'ok');
    });

    test(
      'throws formatted exception when DioException has response data',
      () async {
        final requestOptions = RequestOptions(path: '/users');
        final dioException = DioException(
          requestOptions: requestOptions,
          response: Response(
            requestOptions: requestOptions,
            statusCode: 400,
            data: {
              'message_code': 'INVALID_INPUT',
              'message': 'Validation failed',
            },
          ),
        );

        Future<String> call() =>
            apiCallWrapper<String>(() async => throw dioException);

        await expectLater(
          call,
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('INVALID_INPUT: Validation failed'),
            ),
          ),
        );
      },
    );

    test(
      'throws network exception when DioException has no response',
      () async {
        final requestOptions = RequestOptions(path: '/users');
        final dioException = DioException(
          requestOptions: requestOptions,
          message: 'Socket timeout',
        );

        Future<String> call() =>
            apiCallWrapper<String>(() async => throw dioException);

        await expectLater(
          call,
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Network error: Socket timeout'),
            ),
          ),
        );
      },
    );

    test('rethrows non-Dio exceptions', () async {
      Future<String> call() =>
          apiCallWrapper<String>(() async => throw StateError('boom'));

      await expectLater(call, throwsA(isA<StateError>()));
    });
  });
}
