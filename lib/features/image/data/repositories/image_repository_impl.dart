import 'dart:typed_data';

import 'package:Dividex/features/image/data/models/image_presign_url_model.dart';
import 'package:Dividex/features/image/data/source/image_remote_data_source.dart';
import 'package:Dividex/features/image/domain/image_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ImageRepository)
class ImageRepositoryImpl implements ImageRepository {
  final ImageRemoteDataSource remoteDataSource;

  ImageRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> completeUpload(String instanceUid, List<String> fileUids) {
    return remoteDataSource.completeUpload(instanceUid, fileUids);
  }

  @override
  Future<List<ImagePresignUrlResponseModel>> getPresignedUrls(List<ImagePresignUrlInputModel> files) {
    return remoteDataSource.getPresignedUrls(files);
  }

  @override
  Future<void> uploadImage(String presignedUrl, Uint8List fileBytes) {
    return remoteDataSource.uploadImage(presignedUrl, fileBytes);
  }

  @override
  Future<List<ImagePresignUrlResponseModel>> updateImages(List<ImagePresignUrlInputModel> newFiles, List<String> deletedImageUids) {
    return remoteDataSource.updateImages(newFiles, deletedImageUids);
  }

  @override
  Future<void> deleteImages(List<String> deletedImageUids) {
    return remoteDataSource.deleteImages(deletedImageUids);
  }
}
