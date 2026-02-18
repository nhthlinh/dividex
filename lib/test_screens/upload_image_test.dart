import 'package:Dividex/features/image/presentation/widgets/image_picker_widget.dart';
import 'package:flutter/material.dart';

class UploadDemoPage extends StatelessWidget {
  const UploadDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image Picker Test")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Avatar Upload (1 image)"),
            ImagePickerWidget(
              type: PickerType.avatar,
              onFilesPicked: (files) {
                // debugPrint("Avatar picked: ${files.length}");
              },
            ),
            const SizedBox(height: 32),
            const Text("Gallery Upload (multiple images)"),
            ImagePickerWidget(
              type: PickerType.gallery,
              onFilesPicked: (files) {
                // debugPrint("Gallery picked: ${files.length}");
              },
            ),
          ],
        ),
      ),
    );
  }
}
