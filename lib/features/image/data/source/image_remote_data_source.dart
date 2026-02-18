
import 'dart:typed_data';

import 'package:Dividex/features/image/data/models/image_expense_model.dart';
import 'package:Dividex/features/image/data/models/image_presign_url_model.dart';

abstract class ImageRemoteDataSource {
  Future<void> completeUpload(String instanceUid, List<String> fileUids);
  Future<List<ImagePresignUrlResponseModel>> getPresignedUrls(List<ImagePresignUrlInputModel> files);
  Future<void> uploadImage(String presignedUrl, Uint8List fileBytes);

  Future<List<ImagePresignUrlResponseModel>> updateImages(List<ImagePresignUrlInputModel> newFiles, List<String> deletedImageUids);
  Future<void> deleteImages(List<String> deletedImageUids);
  Future<ImageExpenseModel> uploadExpenseImage(Uint8List fileBytes);
}