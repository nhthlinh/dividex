// DONE

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SimpleImageEditorPage extends StatefulWidget {
  final Uint8List imageBytes;

  const SimpleImageEditorPage({super.key, required this.imageBytes});

  @override
  State<SimpleImageEditorPage> createState() => _SimpleImageEditorPageState();
}

class _SimpleImageEditorPageState extends State<SimpleImageEditorPage> {
  double _rotation = 0.0;
  bool _flipX = false;
  bool _flipY = false;

  final GlobalKey _cropKey = GlobalKey();

  Future<void> _saveEdited() async {
    // Render lại ảnh từ widget crop container
    final boundary =
        _cropKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 2.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (context.mounted) {
      Navigator.pop(context, byteData?.buffer.asUint8List());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // nền đen
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
          color: Colors.white,
        ),
        title: Text("Edit Image", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveEdited,
            color: Colors.white,
          ),
        ],
      ),
      body: Center(
        child: RepaintBoundary(
          key: _cropKey,
          child: Container(
            color: Colors.black,
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateZ(_rotation)
                  ..scale(_flipX ? -1.0 : 1.0, _flipY ? -1.0 : 1.0),
                child: Image.memory(widget.imageBytes),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.rotate_left, color: Colors.white),
              onPressed: () {
                setState(() => _rotation -= 0.1);
              },
            ),
            IconButton(
              icon: const Icon(Icons.rotate_right, color: Colors.white),
              onPressed: () {
                setState(() => _rotation += 0.1);
              },
            ),
            IconButton(
              icon: const Icon(Icons.flip, color: Colors.white),
              onPressed: () {
                setState(() => _flipX = !_flipX);
              },
            ),
            IconButton(
              icon: const Icon(Icons.flip_camera_android, color: Colors.white),
              onPressed: () {
                setState(() => _flipY = !_flipY);
              },
            ),
            IconButton(
              icon: const Icon(Icons.crop, color: Colors.white),
              onPressed: () {
                // crop = hiện InteractiveViewer đã wrap
                // ở đây không cần action riêng, Save sẽ lấy vùng hiển thị
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Zoom/pan để chọn vùng crop")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
