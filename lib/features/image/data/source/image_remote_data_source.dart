
import 'dart:typed_data';

import 'package:Dividex/features/image/data/models/image_presign_url_model.dart';

abstract class ImageRemoteDataSource {
  Future<void> completeUpload(String instanceUid, List<String> fileUids);
  Future<List<ImagePresignUrlResponseModel>> getPresignedUrls(List<ImagePresignUrlInputModel> files);
  Future<void> uploadImage(String presignedUrl, Uint8List fileBytes);
}