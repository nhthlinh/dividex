import 'dart:typed_data';

import 'package:Dividex/features/image/data/models/image_presign_url_model.dart';


class ImageEvent {}

class GetPresignedUrlEvent extends ImageEvent {
  final List<ImagePresignUrlInputModel> files;

  GetPresignedUrlEvent({required this.files});
}

class UploadImageEvent extends ImageEvent {
  final String presignedUrl;
  final Uint8List fileBytes;

  UploadImageEvent({required this.presignedUrl, required this.fileBytes});
}

class CompleteUploadEvent extends ImageEvent {
  final String instanceUid;
  final List<String> fileUids;

  CompleteUploadEvent({required this.instanceUid, required this.fileUids});
}