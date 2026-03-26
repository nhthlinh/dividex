import 'dart:typed_data';

import 'package:Dividex/core/network/dio_client.dart';
import 'package:Dividex/features/image/data/models/image_expense_model.dart';
import 'package:Dividex/features/image/data/models/image_presign_url_model.dart';
import 'package:Dividex/features/image/data/source/image_remote_data_source_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockDioClient extends Mock implements DioClient {}

void main() {
  late DioClient dioClient;
  late ImageRemoteDatasourceImpl datasource;

  setUp(() {
    dioClient = _MockDioClient();
    datasource = ImageRemoteDatasourceImpl(dioClient);
  });

  group('ImageRemoteDatasourceImpl.completeUpload', () {
    test('sends instance uid and file uids to endpoint', () async {
      when(
        () => dioClient.put(
          '/attachments/inst1/completed',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/attachments/inst1/completed'),
          data: {},
        ),
      );

      await datasource.completeUpload('inst1', ['file1', 'file2']);

      verify(
        () => dioClient.put(
          '/attachments/inst1/completed',
          data: {'list_uids': ['file1', 'file2']},
          queryParameters: null,
          options: null,
        ),
      ).called(1);
    });

    test('handles empty file list', () async {
      when(
        () => dioClient.put(
          '/attachments/inst2/completed',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/attachments/inst2/completed'),
          data: {},
        ),
      );

      await datasource.completeUpload('inst2', []);

      verify(
        () => dioClient.put(
          '/attachments/inst2/completed',
          data: {'list_uids': []},
          queryParameters: null,
          options: null,
        ),
      ).called(1);
    });
  });

  group('ImageRemoteDatasourceImpl.getPresignedUrls', () {
    test('maps response to ImagePresignUrlResponseModel list', () async {
      when(
        () => dioClient.post(
          '/attachments/presigned-url',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/attachments/presigned-url'),
          data: {
            'data': [
              {'uid': 'u1', 'url': 'http://s3.com/file1', 'file_name': 'f1.jpg'},
              {'uid': 'u2', 'url': 'http://s3.com/file2', 'file_name': 'f2.jpg'},
            ],
          },
        ),
      );

      final files = [
        ImagePresignUrlInputModel(
          fileName: 'f1.jpg',
          attachmentType: AttachmentType.expense,
          fileSize: 1024,
        ),
      ];

      final result = await datasource.getPresignedUrls(files);

      expect(result.length, 2);
      expect(result.first.uid, 'u1');
      expect(result.first.url, 'http://s3.com/file1');
      expect(result[1].fileName, 'f2.jpg');
    });

    test('serializes input models to JSON', () async {
      when(
        () => dioClient.post(
          '/attachments/presigned-url',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/attachments/presigned-url'),
          data: {'data': []},
        ),
      );

      final files = [
        ImagePresignUrlInputModel(
          fileName: 'test.jpg',
          attachmentType: AttachmentType.user,
          fileSize: 2048,
        ),
      ];

      await datasource.getPresignedUrls(files);

      verify(
        () => dioClient.post(
          '/attachments/presigned-url',
          data: {
            'files': [
              {
                'file_name': 'test.jpg',
                'attachment_type': 'USER',
                'file_size': 2048,
              },
            ],
          },
          queryParameters: null,
          options: null,
        ),
      ).called(1);
    });

    test('returns empty list when response data is empty', () async {
      when(
        () => dioClient.post(
          '/attachments/presigned-url',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/attachments/presigned-url'),
          data: {'data': []},
        ),
      );

      final result = await datasource.getPresignedUrls([]);

      expect(result, isEmpty);
    });
  });

  group('ImageRemoteDatasourceImpl.updateImages', () {
    test('sends new files and deleted uids to endpoint', () async {
      when(
        () => dioClient.put(
          '/attachments/image',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/attachments/image'),
          data: {
            'data': [
              {'uid': 'new1', 'url': 'http://s3.com/new1', 'file_name': 'new1.jpg'},
            ],
          },
        ),
      );

      final newFiles = [
        ImagePresignUrlInputModel(
          fileName: 'new1.jpg',
          attachmentType: AttachmentType.group,
          fileSize: 512,
        ),
      ];

      final result = await datasource.updateImages(newFiles, ['old1', 'old2']);

      expect(result.length, 1);
      expect(result.first.uid, 'new1');
      verify(
        () => dioClient.put(
          '/attachments/image',
          data: {
            'files': [
              {
                'file_name': 'new1.jpg',
                'attachment_type': 'GROUP',
                'file_size': 512,
              },
            ],
            'list_deleted_uids': ['old1', 'old2'],
          },
          queryParameters: null,
          options: null,
        ),
      ).called(1);
    });

    test('handles empty new files and deleted uids', () async {
      when(
        () => dioClient.put(
          '/attachments/image',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/attachments/image'),
          data: {'data': []},
        ),
      );

      final result = await datasource.updateImages([], []);

      expect(result, isEmpty);
      verify(
        () => dioClient.put(
          '/attachments/image',
          data: {
            'files': [],
            'list_deleted_uids': [],
          },
          queryParameters: null,
          options: null,
        ),
      ).called(1);
    });
  });

  group('ImageRemoteDatasourceImpl.deleteImages', () {
    test('sends list of uids to delete endpoint', () async {
      when(
        () => dioClient.delete(
          '/attachments',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/attachments'),
          data: {},
        ),
      );

      await datasource.deleteImages(['uid1', 'uid2', 'uid3']);

      verify(
        () => dioClient.delete(
          '/attachments',
          data: {'list_uids': ['uid1', 'uid2', 'uid3']},
          queryParameters: null,
        ),
      ).called(1);
    });

    test('handles single uid deletion', () async {
      when(
        () => dioClient.delete(
          '/attachments',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/attachments'),
          data: {},
        ),
      );

      await datasource.deleteImages(['single_uid']);

      verify(
        () => dioClient.delete(
          '/attachments',
          data: {'list_uids': ['single_uid']},
          queryParameters: null,
        ),
      ).called(1);
    });
  });

  group('ImageRemoteDatasourceImpl.uploadExpenseImage', () {
    test('maps response to ImageExpenseModel', () async {
      when(
        () => dioClient.post(
          '/attachments/ocr/upload',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/attachments/ocr/upload'),
          data: {
            'data': {
              'items': [],
              'name': 'Lunch',
              'category': 'Food',
              'total_amount': 50.0,
              'currency': 'VND',
              'note': 'Office lunch',
              'expense_date': '2026-03-26T12:00:00.000Z',
              'end_date': null,
            },
          },
        ),
      );

      final fileBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
      final result = await datasource.uploadExpenseImage(fileBytes);

      expect(result.name, 'Lunch');
      expect(result.category, 'Food');
      expect(result.totalAmount, 50.0);
      expect(result.currency, 'VND');
      expect(result.note, 'Office lunch');
      expect(result.expenseDate, isNotNull);
    });

    test('creates multipart form data with receipt filename', () async {
      when(
        () => dioClient.post(
          '/attachments/ocr/upload',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/attachments/ocr/upload'),
          data: {
            'data': {
              'items': [],
              'name': 'Test',
              'category': null,
              'total_amount': 0,
              'currency': 'VND',
              'note': null,
              'expense_date': null,
              'end_date': null,
            },
          },
        ),
      );

      final fileBytes = Uint8List.fromList([10, 20, 30]);
      await datasource.uploadExpenseImage(fileBytes);

      verify(
        () => dioClient.post(
          '/attachments/ocr/upload',
          data: any(named: 'data'),
          queryParameters: null,
          options: any(named: 'options'),
        ),
      ).called(1);
    });

    test('handles null optional fields in response', () async {
      when(
        () => dioClient.post(
          '/attachments/ocr/upload',
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/attachments/ocr/upload'),
          data: {
            'data': {
              'items': [],
              'name': 'Minimal',
              'category': null,
              'total_amount': 100.5,
              'currency': 'USD',
              'note': null,
              'expense_date': null,
              'end_date': null,
            },
          },
        ),
      );

      final result = await datasource.uploadExpenseImage(Uint8List(0));

      expect(result.category, isNull);
      expect(result.note, isNull);
      expect(result.expenseDate, isNull);
      expect(result.endDate, isNull);
    });
  });
}