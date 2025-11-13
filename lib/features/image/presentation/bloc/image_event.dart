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

class UpdateImageEvent extends ImageEvent {
  final List<ImagePresignUrlInputModel> newFiles;
  final List<String> deletedImageUids;

  UpdateImageEvent({required this.newFiles, required this.deletedImageUids});
}

class DeleteImageEvent extends ImageEvent {
  final List<String> deletedImageUids;

  DeleteImageEvent({required this.deletedImageUids});
}