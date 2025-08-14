import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:video_thumbnail/video_thumbnail.dart';

class CustomImage {
  final File? file;
  final String? url;
  final bool isLocal;
  final Uint8List? thumbnail;
  final String? thumbnailUrl;   

  CustomImage.local(this.file)
      : url = null,
        isLocal = true,
        thumbnail = null,
        thumbnailUrl = null;

  CustomImage.network(this.url)
      : file = null,
        isLocal = false,
        thumbnail = null,
        thumbnailUrl = null;

  CustomImage({
    this.file,
    this.url,
    required this.isLocal,
    this.thumbnail,
    this.thumbnailUrl,
  });

  CustomImage copyWith({
    File? file,
    String? url,
    bool? isLocal,
    Uint8List? thumbnail,
    String? thumbnailUrl
  }) {
    return CustomImage(
      file: file ?? this.file,
      url: url ?? this.url,
      isLocal: isLocal ?? this.isLocal,
      thumbnail: thumbnail ?? this.thumbnail,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl
    );
  }

  static Future<CustomImage> fromVideoFile(File file) async {
    final thumb = await VideoThumbnail.thumbnailData(
      video: file.path,
      imageFormat: ImageFormat.JPEG,
      quality: 75,
    );

    return CustomImage(
      file: file,
      isLocal: true,
      thumbnail: thumb,
    );
  }

  @override
  String toString() {
    if (isLocal) {
      return file?.path ?? '';
    } else {
      return url ?? '';
    }
  }

  static Future<CustomImage> fromVideoUrl(String videoUrl) async {
    try {
      // Loại bỏ ".mp4" ở cuối (nếu có)
      String baseUrl = videoUrl;
      if (baseUrl.endsWith('.mp4')) {
        baseUrl = baseUrl.substring(0, baseUrl.length - 4);
      }

      // Tạo thumbnail URL đúng định dạng
      final thumbUrl = '${baseUrl.replaceFirst('/upload/', '/upload/so_3,du_1/')}.jpg';
      print('✅ Thumbnail URL: $thumbUrl');

      final response = await http.get(Uri.parse(thumbUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to download thumbnail image, status: ${response.statusCode}');
      }

      return CustomImage(
        url: videoUrl,
        isLocal: false,
        thumbnail: response.bodyBytes,
      );
    } catch (e) {
      return CustomImage.network(videoUrl);
    }
  }

}

