import 'dart:typed_data';

import 'package:Dividex/core/network/dio_client.dart';
import 'package:Dividex/features/image/data/models/image_presign_url_model.dart';
import 'package:Dividex/features/image/data/source/image_remote_data_source.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ImageRemoteDataSource)
class ImageRemoteDatasourceImpl implements ImageRemoteDataSource {
  final DioClient dio;

  ImageRemoteDatasourceImpl(this.dio);

  @override
  Future<void> completeUpload(String instanceUid, List<String> fileUids) {
    return apiCallWrapper(() async {
      await dio.put(
        '/attachments/$instanceUid/completed',
        data: {'list_uids': fileUids},
      );
    });
  }

  @override
  Future<List<ImagePresignUrlResponseModel>> getPresignedUrls(
    List<ImagePresignUrlInputModel> files,
  ) {
    return apiCallWrapper(() async {
      final response = await dio.post(
        '/attachments/presigned-url',
        data: {'files': files.map((e) => e.toJson()).toList()},
      );

      final data = response.data['data'] as List;
      return data.map((e) => ImagePresignUrlResponseModel.fromJson(e)).toList();
    });
  }

  @override
  Future<void> uploadImage(String presignedUrl, Uint8List fileBytes) {
    return apiCallWrapper(() async {
      final s3Dio = Dio();
      await s3Dio.put(
        presignedUrl,
        data: fileBytes,
        options: Options(
          headers: {
            'Content-Type': 'image/jpeg',
            'Authorization': null, // ép xóa header này
          },
        ),
      );
    });
  }

  @override
  Future<List<ImagePresignUrlResponseModel>> updateImages(List<ImagePresignUrlInputModel> newFiles, List<String> deletedImageUids) {
    return apiCallWrapper(() async {
      final response = await dio.put(
        '/attachments/image',
        data: {
          'files': newFiles.map((e) => e.toJson()).toList(),
          'list_deleted_uids': deletedImageUids,
        },
      );

      final data = response.data['data'] as List;
      return data.map((e) => ImagePresignUrlResponseModel.fromJson(e)).toList();
    });
  }

  @override
  Future<void> deleteImages(List<String> deletedImageUids) {
    return apiCallWrapper(() async {
      await dio.delete(
        '/attachments',
        data: {
          'list_uids': deletedImageUids,
        },
      );
    });
  }
}
