import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerField extends StatefulWidget {
  final bool isAvatar;
  final bool multiple; // true = nhiều ảnh
  final void Function(List<String> imagePaths)? onChanged; // callback trả link/path

  const ImagePickerField({
    super.key,
    this.isAvatar = false,
    this.multiple = false,
    this.onChanged,
  });

  @override
  State<ImagePickerField> createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  final ImagePicker _picker = ImagePicker();
  List<String> _imagePaths = []; // path hoặc link
  List<Uint8List> _webImages = []; // dành cho web (bytes để hiển thị)

  Future<void> _pickImages() async {
    try {
      final List<XFile> images;

      if (widget.multiple) {
        images = await _picker.pickMultiImage() ?? [];
      } else {
        final XFile? img = await _picker.pickImage(source: ImageSource.gallery);
        images = img != null ? [img] : [];
      }

      if (images.isNotEmpty) {
        _imagePaths = images.map((e) => e.path).toList();
        _webImages.clear();

        if (kIsWeb) {
          for (final img in images) {
            final bytes = await img.readAsBytes();
            _webImages.add(bytes);
          }
        }

        setState(() {});
        widget.onChanged?.call(_imagePaths);
      }
    } catch (e) {
      debugPrint("Image pick error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isAvatar) {
      return GestureDetector(
        onTap: _pickImages,
        child: CircleAvatar(
          radius: 50,
          backgroundImage: _buildAvatarProvider(),
          child: _imagePaths.isEmpty && _webImages.isEmpty
              ? const Icon(Icons.person, size: 50)
              : null,
        ),
      );
    }

    return GestureDetector(
      onTap: _pickImages,
      child: Container(
        height: 150,
        width: double.infinity,
        color: Colors.grey[300],
        child: _buildGallery(),
      ),
    );
  }

  ImageProvider? _buildAvatarProvider() {
    if (kIsWeb) {
      if (_webImages.isNotEmpty) {
        return MemoryImage(_webImages.first);
      }
    } else {
      if (_imagePaths.isNotEmpty) {
        if (_imagePaths.first.startsWith("http")) {
          return NetworkImage(_imagePaths.first);
        } else {
          return AssetImage(_imagePaths.first); // tạm coi như local asset
        }
      }
    }
    return null;
  }

  Widget _buildGallery() {
    if (_imagePaths.isEmpty && _webImages.isEmpty) {
      return const Center(child: Icon(Icons.photo_camera, size: 40));
    }

    final children = <Widget>[];
    if (kIsWeb) {
      children.addAll(_webImages.map(
        (bytes) => Image.memory(bytes, fit: BoxFit.cover),
      ));
    } else {
      children.addAll(_imagePaths.map(
        (path) => path.startsWith("http")
            ? Image.network(path, fit: BoxFit.cover)
            : Image.asset(path, fit: BoxFit.cover),
      ));
    }

    if (widget.multiple) {
      return ListView(
        scrollDirection: Axis.horizontal,
        children: children
            .map((e) => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SizedBox(width: 120, child: e),
                ))
            .toList(),
      );
    } else {
      return children.first;
    }
  }
}
