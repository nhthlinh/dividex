import 'dart:typed_data';

import 'package:Dividex/features/image/data/models/image_presign_url_model.dart';
import 'package:Dividex/features/image/domain/image_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ImageUseCase {
  final ImageRepository imageRepository;

  ImageUseCase({required this.imageRepository});

  Future<List<ImagePresignUrlResponseModel>> getPresignedUrls(List<ImagePresignUrlInputModel> files) async {
    return await imageRepository.getPresignedUrls(files);
  }

  Future<void> uploadImage(String presignedUrl, Uint8List fileBytes) async {
    return await imageRepository.uploadImage(presignedUrl, fileBytes);
  }

  Future<void> completeUpload(String instanceUid, List<String> fileUids) async {
    return await imageRepository.completeUpload(instanceUid, fileUids);
  }
}