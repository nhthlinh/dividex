import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<Uint8List> compressImage(Uint8List bytes) async {
  final result = await FlutterImageCompress.compressWithList(
    bytes,
    quality: 75,
  );
  return result;
}
