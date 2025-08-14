import 'dart:io';
import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/shared/widgets/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerAndEditorScreen extends StatefulWidget {
  const ImagePickerAndEditorScreen({super.key});

  @override
  State<ImagePickerAndEditorScreen> createState() => _ImagePickerAndEditorScreenState();
}

class _ImagePickerAndEditorScreenState extends State<ImagePickerAndEditorScreen> {
  final List<File> _images = []; // Danh sách để lưu các File ảnh đã chọn và chỉnh sửa

  @override
  Widget build(BuildContext context) {
    // Đây chỉ là một ví dụ về AppLocalizations, bạn cần thay thế bằng cách triển khai thực tế của mình
    final intl = AppLocalizations.of(context)!; 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn và Chỉnh sửa Ảnh'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(
                      _images[index],
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _images.removeAt(index); // Xóa ảnh khi nhấn vào biểu tượng x
                          });
                        },
                        child: const CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.red,
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _pickImages, 
              child: Text(intl.imagePicker1), // "Chọn ảnh từ thư viện"
            ),
          ),
        ],
      ),
    );
  }

  // Hàm chọn nhiều ảnh được viết lại
  Future<void> _pickImages() async {
    final intl = AppLocalizations.of(context)!; 
    final picker = ImagePicker();
    List<XFile>? pickedFiles;

    try {
      final ImageSource? source = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: Text(intl.imagePicker1), // "Chọn từ thư viện"
                  onTap: () {
                    Navigator.pop(context, ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: Text(intl.imagePicker2), // "Chụp ảnh"
                  onTap: () {
                    Navigator.pop(context, ImageSource.camera);
                  },
                ),
              ],
            ),
          );
        },
      );

      if (source == ImageSource.gallery) {
        // Cho phép chọn nhiều ảnh từ thư viện
        pickedFiles = await picker.pickMultiImage();
      } else if (source == ImageSource.camera) {
        // Chụp một ảnh từ camera
        final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
        if (pickedFile != null) {
          pickedFiles = [pickedFile];
        }
      }
    } catch (e) {
      // Hiển thị thông báo lỗi thân thiện cho người dùng
      showCustomToast(
        intl.imagePickerError1,
        type: ToastType.error,
      );
    }

    // Kiểm tra xem có ảnh nào được chọn không
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      for (XFile pickedFile in pickedFiles) {
        // Gọi hàm chỉnh sửa ảnh cho từng ảnh
        final croppedFile = await _cropImage(File(pickedFile.path));
        if (croppedFile != null) {
          setState(() {
            _images.add(croppedFile);
          });
        }
      }
    } 
  }

  // Hàm chỉnh sửa ảnh (cắt, xoay, lật)
  Future<File?> _cropImage(File imageFile) async {
    // Trong thực tế, bạn sẽ lấy intl từ AppLocalizations.of(context)!
    final intl = AppLocalizations.of(context)!; 

    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: intl.cropImage, // "Chỉnh sửa ảnh"
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false, // Cho phép thay đổi tỷ lệ khung hình
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
        ),
        IOSUiSettings(
          title: intl.cropImage, // "Chỉnh sửa ảnh"
          aspectRatioLockEnabled: false, // Cho phép thay đổi tỷ lệ khung hình
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
        ),
      ],
    );

    if (croppedFile != null) {
      return File(croppedFile.path);
    } else {
      return null;
    }
  }
}