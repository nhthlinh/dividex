import 'dart:typed_data';

import 'package:Dividex/features/image/data/models/image_presign_url_model.dart';
import 'package:Dividex/features/image/data/repositories/image_repository_impl.dart';
import 'package:Dividex/features/image/data/source/image_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockImageRemoteDataSource extends Mock implements ImageRemoteDataSource {}

void main() {
  late ImageRemoteDataSource remoteDataSource;
  late ImageRepositoryImpl repository;

  setUp(() {
    remoteDataSource = _MockImageRemoteDataSource();
    repository = ImageRepositoryImpl(remoteDataSource);
  });

  test('getPresignedUrls delegates to remote data source', () async {
    final files = <ImagePresignUrlInputModel>[
      ImagePresignUrlInputModel(fileName: 'a.jpg', fileSize: 100, attachmentType: AttachmentType.group),
    ];
    final response = <ImagePresignUrlResponseModel>[
      ImagePresignUrlResponseModel(uid: 'img-1', url: 'https://s3/a.jpg', fileName: 'a.jpg'),
    ];
    when(() => remoteDataSource.getPresignedUrls(files)).thenAnswer((_) async => response);

    final result = await repository.getPresignedUrls(files);

    expect(result.first.uid, 'img-1');
    verify(() => remoteDataSource.getPresignedUrls(files)).called(1);
  });

  test('uploadImage delegates with bytes', () async {
    final bytes = Uint8List.fromList(<int>[1, 2, 3]);
    when(() => remoteDataSource.uploadImage('https://s3/a.jpg', bytes)).thenAnswer((_) async {});

    await repository.uploadImage('https://s3/a.jpg', bytes);

    verify(() => remoteDataSource.uploadImage('https://s3/a.jpg', bytes)).called(1);
  });
}
