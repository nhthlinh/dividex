import 'package:Dividex/features/image/data/models/image_presign_url_model.dart';

class ImageState {}

class ImageInitial extends ImageState {}

class GetPresignedUrlSuccess extends ImageState {
  final List<ImagePresignUrlResponseModel> presignedUrls;

  GetPresignedUrlSuccess({required this.presignedUrls});
}