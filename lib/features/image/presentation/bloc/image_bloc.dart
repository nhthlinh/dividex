import 'dart:typed_data';

import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/image/data/models/image_presign_url_model.dart';
import 'package:Dividex/features/image/domain/usecase.dart';
import 'package:Dividex/features/image/presentation/bloc/image_event.dart';
import 'package:Dividex/features/image/presentation/bloc/image_state.dart';
import 'package:Dividex/shared/utils/image_compress.dart';
import 'package:Dividex/shared/widgets/push_noti_in_app_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  ImageBloc() : super(ImageInitial()) {
    on<GetPresignedUrlEvent>(_onGetPresignedUrl);
    on<UploadImageEvent>(_onUploadImage);
    on<UpdateImageEvent>(_onUpdateImage);
    on<DeleteImageEvent>(_onDeleteImage);
    on<CompleteUploadEvent>(_onCompleteUpload);
  }

  Future<void> _onGetPresignedUrl(
    GetPresignedUrlEvent event,
    Emitter<ImageState> emit,
  ) async {
    try {
      final usecase = await getIt.getAsync<ImageUseCase>();
      final urls = await usecase.getPresignedUrls(event.files);
      emit(GetPresignedUrlSuccess(presignedUrls: urls));
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future<void> _onUploadImage(
    UploadImageEvent event,
    Emitter<ImageState> emit,
  ) async {
    try {
      final usecase = await getIt.getAsync<ImageUseCase>();
      await usecase.uploadImage(event.presignedUrl, event.fileBytes);
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future<void> _onCompleteUpload(
    CompleteUploadEvent event,
    Emitter<ImageState> emit,
  ) async {
    try {
      final usecase = await getIt.getAsync<ImageUseCase>();
      await usecase.completeUpload(event.instanceUid, event.fileUids);
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future<void> _onUpdateImage(
    UpdateImageEvent event,
    Emitter<ImageState> emit,
  ) async {
    try {
      final usecase = await getIt.getAsync<ImageUseCase>();
      await usecase.updateImages(event.newFiles, event.deletedImageUids);
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future<void> _onDeleteImage(
    DeleteImageEvent event,
    Emitter<ImageState> emit,
  ) async {
    try {
      final usecase = await getIt.getAsync<ImageUseCase>();
      await usecase.deleteImages(event.deletedImageUids);
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }
}

Future<void> uploadImage(
  String instanceUid,
  List<Uint8List> imageBytes,
  AttachmentType type,
) async {
  try {
    List<ImagePresignUrlInputModel> fileParams = [];
    List<Uint8List> compressedImages = [];

    for (var bytes in imageBytes) {
      // 1️⃣ Nén ảnh
      final compressed = await compressImage(bytes);
      compressedImages.add(compressed);

      // 2️⃣ Chuẩn bị file param
      final fileName = "avatar_${DateTime.now().millisecondsSinceEpoch}.jpg";
      final fileSize = compressed.length;

      final fileParam = ImagePresignUrlInputModel(
        fileName: fileName,
        fileSize: fileSize,
        attachmentType: type,
      );
      fileParams.add(fileParam);
    }

    final imageUsecase = await getIt.getAsync<ImageUseCase>();

    // 3️⃣ Gọi API lấy presigned url
    final presignedList = await imageUsecase.getPresignedUrls(fileParams);
    if (presignedList.isEmpty) {
      throw Exception("Presigned URL not received");
    } 

    for (int i = 0; i < presignedList.length; i++) {
      final presigned = presignedList[i];
      final compressed = compressedImages[i];

      // 4️⃣ Upload bytes lên S3 bằng presigned url
      await imageUsecase.uploadImage(
        presigned.url, // BE trả về trong model
        compressed,
      );
    }

    // 5️⃣ Complete upload
    await imageUsecase.completeUpload(
      instanceUid,
      presignedList.map((e) => e.uid).toList(), // uid BE cấp
    );

    // print("✅ Upload thành công");
  } catch (e) {
    // print("❌ Upload image failed: $e");
  }
}

Future<void> updateImage(
  String instanceUid,
  List<Uint8List> imageBytes,
  AttachmentType type,
  List<String> deletedImageUids,
) async {
  try {
    List<ImagePresignUrlInputModel> fileParams = [];
    List<Uint8List> compressedImages = [];

    for (var bytes in imageBytes) {
      // 1️⃣ Nén ảnh
      final compressed = await compressImage(bytes);
      compressedImages.add(compressed);

      // 2️⃣ Chuẩn bị file param
      final fileName = "avatar_${DateTime.now().millisecondsSinceEpoch}.jpg";
      final fileSize = compressed.length;

      final fileParam = ImagePresignUrlInputModel(
        fileName: fileName,
        fileSize: fileSize,
        attachmentType: type,
      );
      fileParams.add(fileParam);
    }

    final imageUsecase = await getIt.getAsync<ImageUseCase>();

    // 3️⃣ Gọi API lấy presigned url
    final presignedList = await imageUsecase.updateImages(fileParams, deletedImageUids);
    if (presignedList.isEmpty) {
      throw Exception("Presigned URL not received");
    } 

    for (int i = 0; i < presignedList.length; i++) {
      final presigned = presignedList[i];
      final compressed = compressedImages[i];

      // 4️⃣ Upload bytes lên S3 bằng presigned url
      await imageUsecase.uploadImage(
        presigned.url, // BE trả về trong model
        compressed,
      );
    }

    // 5️⃣ Complete upload
    await imageUsecase.completeUpload(
      instanceUid,
      presignedList.map((e) => e.uid).toList(), // uid BE cấp
    );

    // print("✅ Upload thành công");
  } catch (e) {
    // print("❌ Upload image failed: $e");
  }
}

Future<void> deleteImage(
  List<String> deletedImageUids,
) async {
  try {
    final imageUsecase = await getIt.getAsync<ImageUseCase>();

    await imageUsecase.deleteImages(deletedImageUids);
  } catch (e) {
    // print("❌ Delete image failed: $e");
  }
}