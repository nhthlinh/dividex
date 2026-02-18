// DONE

import 'dart:io' as io;
import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/features/image/presentation/widgets/image_edit_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum PickerType { avatar, gallery }

class ImagePickerWidget extends StatefulWidget {
  final Uint8List? initialImage;
  final PickerType type;
  final void Function(List<Uint8List> files) onFilesPicked;

  const ImagePickerWidget({
    super.key,
    this.initialImage,
    required this.type,
    required this.onFilesPicked,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  List<Uint8List> _previewFiles = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialImage != null) {
      _previewFiles = [widget.initialImage!];
    }
  }

  Future<void> _pickFiles() async {
    if (kIsWeb) {
      // --- WEB: dùng FilePicker
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: widget.type == PickerType.gallery,
      );
      if (result != null) {
        setState(() {
          _previewFiles = result.files.map((file) => file.bytes!).toList();
        });
        widget.onFilesPicked(_previewFiles);
      }
    } else {
      // --- MOBILE: dùng ImagePicker
      final picker = ImagePicker();
      if (widget.type == PickerType.avatar) {
        final XFile? file = await picker.pickImage(source: ImageSource.gallery);
        if (file != null) {
          final bytes = await io.File(file.path).readAsBytes();
          setState(() => _previewFiles = [bytes]);
          widget.onFilesPicked(_previewFiles);
        }
      } else {
        final List<XFile> files = await picker.pickMultiImage();
        if (files.isNotEmpty) {
          final data = await Future.wait(
            files.map((f) => io.File(f.path).readAsBytes()),
          );
          setState(() => _previewFiles = data);
          widget.onFilesPicked(_previewFiles);
        }
      }
    }
  }

  /// Xóa ảnh
  void _removeImage(int index) {
    setState(() {
      _previewFiles.removeAt(index);
    });
    widget.onFilesPicked(_previewFiles);
  }

  Future<void> _editImage(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SimpleImageEditorPage(imageBytes: _previewFiles[index]),
      ),
    );

    if (result != null && result is Uint8List) {
      setState(() {
        _previewFiles[index] = result;
      });
      widget.onFilesPicked(List<Uint8List>.from(_previewFiles));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAvatar = widget.type == PickerType.avatar;
    final intl = AppLocalizations.of(context)!;

    return SizedBox(
      width: 340,
      child: Column(
        children: [
          Text(
            intl.uploadImageHint,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppThemes.borderColor,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),

          // Upload button + status
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                text: intl.chooseFile,
                onPressed: _pickFiles,
                type: ButtonType.secondary,
                size: ButtonSize.medium,
              ),
              const SizedBox(width: 8),
              Text(
                _previewFiles.isEmpty
                    ? intl.noFileChosen
                    : '${_previewFiles.length} ${intl.fileChosen}',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Preview
          if (_previewFiles.isEmpty)
            Container(
              width: isAvatar ? 120 : 160,
              height: isAvatar ? 120 : 160,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: isAvatar ? BoxShape.circle : BoxShape.rectangle,
              ),
              child: const Icon(Icons.image, size: 50, color: Colors.grey),
            )
          else if (isAvatar)
            Stack(
              children: [
                InkWell(
                  onTap: () => _editImage(0),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: MemoryImage(_previewFiles.first),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppThemes.borderColor,
                        ),
                        onPressed: () => _removeImage(0),
                      ),
                    ],
                  ),
                ),
              ],
            )
          
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(_previewFiles.length, (i) {
                return Stack(
                  children: [
                    InkWell(
                      onTap: () => _editImage(i),
                      child: Image.memory(
                        _previewFiles[i],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: AppThemes.borderColor,
                            ),
                            onPressed: () => _removeImage(i),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
        ],
      ),
    );
  }
}
