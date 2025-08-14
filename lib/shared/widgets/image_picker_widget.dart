import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Widget buildImagePicker({
  required File? image,
  required VoidCallback onPick,
  required isAvatar,
}) {
  if (isAvatar) {
    return image != null
      ? GestureDetector(
        onTap: onPick, 
        child: CircleAvatar(radius: 50, backgroundImage: buildImagePreview(image))
      )
      : GestureDetector(
        onTap: onPick, 
        child: const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50))
      );
  }

  return GestureDetector(
    onTap: onPick,
    child: Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        image: image != null
            ? DecorationImage(
                image: buildImagePreview(image),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: image == null
          ? const Center(child: Icon(Icons.photo_camera))
          : null,
    ),
  );
}

ImageProvider buildImagePreview(File image) {
  if (kIsWeb) {
    return NetworkImage(image.path);
  } else {
    if (image.path.startsWith('http')) {
      // Nếu là đường dẫn URL (ảnh từ Cloudinary...)
      return NetworkImage(image.path);
    } else {
      // Nếu là đường dẫn local (ảnh người dùng chọn)
      return FileImage(File(image.path));
    }
  }
}

