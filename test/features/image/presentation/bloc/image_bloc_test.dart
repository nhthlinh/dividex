import 'dart:async';

import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/image/data/models/image_presign_url_model.dart';
import 'package:Dividex/features/image/domain/usecase.dart';
import 'package:Dividex/features/image/presentation/bloc/image_bloc.dart';
import 'package:Dividex/features/image/presentation/bloc/image_event.dart';
import 'package:Dividex/features/image/presentation/bloc/image_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockImageUseCase extends Mock implements ImageUseCase {}

void main() {
  late ImageUseCase useCase;

  setUp(() async {
    await getIt.reset();
    useCase = _MockImageUseCase();
    getIt.registerSingletonAsync<ImageUseCase>(() async => useCase);
    await getIt.isReady<ImageUseCase>();
  });

  tearDown(() async {
    await getIt.reset();
  });

  test('GetPresignedUrlEvent emits GetPresignedUrlSuccess', () async {
    final files = <ImagePresignUrlInputModel>[
      ImagePresignUrlInputModel(fileName: 'a.jpg', fileSize: 100, attachmentType: AttachmentType.group),
    ];
    final urls = <ImagePresignUrlResponseModel>[
      ImagePresignUrlResponseModel(uid: 'img-1', url: 'https://s3/a.jpg', fileName: 'a.jpg'),
    ];
    when(() => useCase.getPresignedUrls(files)).thenAnswer((_) async => urls);

    final bloc = ImageBloc();
    final completer = Completer<void>();
    late ImageState emitted;
    final sub = bloc.stream.listen((state) {
      emitted = state;
      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    bloc.add(GetPresignedUrlEvent(files: files));
    await completer.future;

    expect(emitted, isA<GetPresignedUrlSuccess>());
    expect((emitted as GetPresignedUrlSuccess).presignedUrls.first.uid, 'img-1');
    verify(() => useCase.getPresignedUrls(files)).called(1);

    await sub.cancel();
    await bloc.close();
  });
}
