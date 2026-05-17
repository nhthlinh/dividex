import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/features/image/presentation/bloc/image_bloc.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

class ExpenseOcrPage extends StatefulWidget {
  const ExpenseOcrPage({super.key});

  @override
  State<ExpenseOcrPage> createState() => _ExpenseOcrPageState();
}

class _ExpenseOcrPageState extends State<ExpenseOcrPage> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(navigatorKey.currentContext!)!;

    return Scaffold(
      appBar: AppBar(title: Text(intl.expenseOcrTitle)),
      body: _loading
          ? const Center(
              child: ColoredBox(
                color: Colors.transparent,
                child: SpinKitFadingCircle(color: AppThemes.primary3Color),
              ),
            )
          : _buildButtons(context),
    );
  }

  Widget _buildButtons(BuildContext context) {
    final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButton(
            text: intl.takePhoto,
            onPressed: () {
              _pickImage(context, ImageSource.camera);
            },
            size: ButtonSize.large,
          ),
          const SizedBox(height: 16),
          CustomButton(
            type: ButtonType.secondary,
            text: intl.fromGallery,
            onPressed: () {
              _pickImage(context, ImageSource.gallery);
            },
            size: ButtonSize.large,
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: source, imageQuality: 85);

    if (file == null) return;

    setState(() => _loading = true);

    try {
      final bytes = await file.readAsBytes();
      final imageInfo = await uploadExpenseImage(bytes);

      if (!mounted) return;

      Navigator.pop(context, {'imageInfo': imageInfo, 'bytes': bytes});
    } catch (e) {
      setState(() => _loading = false);
      debugPrint('OCR error: $e');
    }
  }
}
