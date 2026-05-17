import 'dart:typed_data';

import 'package:Dividex/features/image/data/models/image_expense_model.dart';
import 'package:Dividex/features/image/data/models/image_presign_url_model.dart';
import 'package:Dividex/features/image/domain/image_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ImageUseCase {
  final ImageRepository imageRepository;

  ImageUseCase({required this.imageRepository});

  Future<List<ImagePresignUrlResponseModel>> getPresignedUrls(
    List<ImagePresignUrlInputModel> files,
  ) async {
    // List không trùng và không được rỗng
    final uniqueFiles = files.toSet().toList();
    if (uniqueFiles.isEmpty) {
      throw Exception("Cần ít nhất 1 file để tải lên");
    }
    if (uniqueFiles.length != files.length) {
      throw Exception("Danh sách file có chứa phần tử trùng lặp");
    }
    return await imageRepository.getPresignedUrls(files);
  }

  Future<void> uploadImage(String presignedUrl, Uint8List fileBytes) async {
    return await imageRepository.uploadImage(presignedUrl, fileBytes);
  }

  Future<void> completeUpload(String instanceUid, List<String> fileUids) async {
    return await imageRepository.completeUpload(instanceUid, fileUids);
  }

  Future<List<ImagePresignUrlResponseModel>> updateImages(
    List<ImagePresignUrlInputModel> newFiles,
    List<String> deletedImageUids,
  ) async {
    // List không trùng và không được rỗng
    final uniqueNewFiles = newFiles.toSet().toList();
    if (uniqueNewFiles.length != newFiles.length) {
      throw Exception("Danh sách file mới có chứa phần tử trùng lặp");
    }
    if (deletedImageUids.length != deletedImageUids.toSet().length) {
      throw Exception("Danh sách file xóa có chứa phần tử trùng lặp");
    }
    return await imageRepository.updateImages(newFiles, deletedImageUids);
  }

  Future<void> deleteImages(List<String> deletedImageUids) async {
    if (deletedImageUids.length != deletedImageUids.toSet().length) {
      throw Exception("Danh sách file xóa có chứa phần tử trùng lặp");
    }
    return await imageRepository.deleteImages(deletedImageUids);
  }

  Future<ImageExpenseModel> uploadExpenseImage(Uint8List fileBytes) async {
    return await imageRepository.uploadExpenseImage(fileBytes);
  }
}
