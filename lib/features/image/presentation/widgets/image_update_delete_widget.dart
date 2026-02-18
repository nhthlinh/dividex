import 'dart:io' as io;

import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/image/data/models/image_model.dart';
import 'package:Dividex/features/image/presentation/pages/image_page.dart';
import 'package:Dividex/features/image/presentation/widgets/image_edit_widget.dart';
import 'package:Dividex/features/image/presentation/widgets/image_picker_widget.dart';
import 'package:Dividex/shared/widgets/show_dialog_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUpdateDeleteWidget extends StatefulWidget {
  final String label;
  final String nameForExampleImage;
  final bool isAvatar;
  final PickerType type;
  final List<ImageModel>? images; // Gốc
  final void Function(List<Uint8List> files) onFilesPicked;
  final void Function(ImageModel) onDelete; // Xóa hoặc thay đổi ảnh gốc

  const ImageUpdateDeleteWidget({
    super.key,
    required this.label,
    required this.nameForExampleImage,
    required this.isAvatar,
    required this.type,
    required this.images,
    required this.onFilesPicked,
    required this.onDelete,
  });

  @override
  State<ImageUpdateDeleteWidget> createState() =>
      _ImageUpdateDeleteWidgetState();
}

class _ImageUpdateDeleteWidgetState extends State<ImageUpdateDeleteWidget> {
  List<Uint8List> _previewFiles = [];
  int deleteImageNum = 0;

  Future<void> _pickFiles(int index) async {
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
        if (index != -1) {
          widget.onDelete(widget.images![index]);
        }
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
          if (index != -1) {
            widget.onDelete(widget.images![index]);
          }
        }
      } else {
        final List<XFile> files = await picker.pickMultiImage();
        if (files.isNotEmpty) {
          final data = await Future.wait(
            files.map((f) => io.File(f.path).readAsBytes()),
          );
          setState(() => _previewFiles = data);
          widget.onFilesPicked(_previewFiles);
          if (index != -1) {
            widget.onDelete(widget.images![index]);
          }
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
    // debugPrint('Rebuild ImageUpdateDeleteWidget: ${widget.isAvatar}');
    return SizedBox(
      width: 340,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 12,
                letterSpacing: 0,
                height: 16 / 12,
                color: Colors.grey,
              ),
            ),
          ),
          if (widget.isAvatar) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    handleOnTap(0);
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: (widget.images?.isNotEmpty ?? false)
                        ? (widget.images!.first.publicUrl.isEmpty
                              ? NetworkImage(
                                  'https://ui-avatars.com/api/?name=${Uri.encodeComponent(widget.nameForExampleImage)}&background=random&color=fff&size=128',
                                )
                              : NetworkImage(widget.images!.first.publicUrl))
                        : NetworkImage(
                            'https://ui-avatars.com/api/?name=${Uri.encodeComponent(widget.nameForExampleImage)}&background=random&color=fff&size=128',
                          ),
                  ),
                ),
                if (_previewFiles.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Image.asset('lib/assets/images/arrow_image.png', width: 50),
                  const SizedBox(width: 8),
                  Stack(
                    children: [
                      InkWell(
                        onTap: () => _editImage(0),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: MemoryImage(_previewFiles.first),
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
                              onPressed: () => _removeImage(0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ] else if (deleteImageNum == widget.images!.length &&
                    deleteImageNum > 0) ...[
                  const SizedBox(width: 8),
                  Image.asset('lib/assets/images/arrow_image.png', width: 50),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      'https://ui-avatars.com/api/?name=${Uri.encodeComponent(widget.nameForExampleImage)}&background=random&color=fff&size=128',
                    ),
                  ),
                ],
              ],
            ),
          ] else ...[
            SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.images!.length + _previewFiles.length + 1,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  if (index == widget.images!.length + _previewFiles.length) {
                    return InkWell(
                      onTap: () {
                        _pickFiles(-1);
                      },
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: Icon(
                            Icons.add_photo_alternate,
                            color: AppThemes.borderColor,
                            size: 50,
                          ),
                        ),
                      ),
                    );
                  }

                  if (index < widget.images!.length) {
                    final image = widget.images![index];

                    return InkWell(
                      onTap: () {
                        handleOnTap(index);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          image.publicUrl,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 200,
                              height: 200,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image),
                            );
                          },
                        ),
                      ),
                    );
                  }

                  final image = _previewFiles[index - widget.images!.length];
                  return Stack(
                    children: [
                      InkWell(
                        onTap: () => _editImage(index - widget.images!.length),
                        child: Image.memory(
                          image,
                          width: 200,
                          height: 200,
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
                              onPressed: () =>
                                  _removeImage(index - widget.images!.length),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  void handleOnTap(int index) {
    final intl = AppLocalizations.of(context)!;
    showCustomDialog(
      context: context,
      content: Column(
        children: [
          if (widget.images!.isNotEmpty) ...[
            settingOption(
              intl.seePhoto,
              context,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImagePage(
                      imageBytes: null,
                      imageUrl: widget.images![index].publicUrl,
                    ),
                  ),
                );
              },
            ),
          ],
          settingOption(
            intl.changePhoto,
            context,
            onTap: () {
              _pickFiles(index);
            },
          ),
          if (widget.images!.isNotEmpty) ...[
            settingOption(
              intl.deletePhoto,
              context,
              onTap: () {
                widget.onDelete(widget.images![index]);
                setState(() {
                  deleteImageNum++;
                });
              },
            ),
          ],
        ],
      ),
    );
  }

  InkWell settingOption(
    String label,
    BuildContext context, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppThemes.borderColor,
              ),
            ],
          ),
          const Divider(height: 32, color: AppThemes.borderColor),
        ],
      ),
    );
  }
}
