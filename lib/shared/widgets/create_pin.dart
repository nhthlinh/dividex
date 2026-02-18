import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/user/presentation/bloc/user_bloc.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart';
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/show_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> showCreatePinDialog({required BuildContext context}) async {
  final intl = AppLocalizations.of(context)!;
  final pinControler = TextEditingController();

  return showCustomDialog(
    context: context,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        Text(
          intl.createPinGuide,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppThemes.primary3Color,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),

        CustomTextInputWidget(
          size: TextInputSize.large,
          controller: pinControler,
          label: intl.createPinTitle,
          keyboardType: TextInputType.number,
          isReadOnly: false,
          isRequired: true,
          validator: (value) =>
              CustomValidator().validatePin(pinControler.text, intl),
        ),
        const SizedBox(height: 8),

        // Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomButton(
              text: intl.cancel,
              size: ButtonSize.medium,
              type: ButtonType.secondary,
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 12),
            CustomButton(
              text: intl.save,
              size: ButtonSize.medium,
              onPressed: () {
                context.read<UserBloc>().add(
                  CreatePinEvent(pin: pinControler.text),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    ),
  );
}
