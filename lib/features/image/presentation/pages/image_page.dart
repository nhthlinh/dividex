import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ImagePage extends StatefulWidget {
  final String? imageUrl;
  final Uint8List? imageBytes;

  const ImagePage({super.key, required this.imageBytes, this.imageUrl});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // nền đen
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
          color: Colors.white,
        ),
        title: Text("Edit Image", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
      ),
      body: Center(
        child: RepaintBoundary(
          child: Container(
            color: Colors.black,
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: widget.imageBytes != null
                  ? Image.memory(widget.imageBytes!)
                  : (widget.imageUrl != null
                      ? Image.network(widget.imageUrl!)
                      : const Icon(Icons.broken_image, size: 50, color: Colors.grey)),
            ),
          ),
        ),
      ),
    );
  }
}
