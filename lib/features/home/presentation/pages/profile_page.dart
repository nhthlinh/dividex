import 'dart:typed_data';

import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/image/data/models/image_model.dart';
import 'package:Dividex/features/image/presentation/bloc/image_bloc.dart';
import 'package:Dividex/features/image/presentation/bloc/image_state.dart';
import 'package:Dividex/features/image/presentation/widgets/image_picker_widget.dart';
import 'package:Dividex/features/image/presentation/widgets/image_update_delete_widget.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/presentation/bloc/user_bloc.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart';
import 'package:Dividex/features/user/presentation/bloc/user_state.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_dropdown_widget.dart';
import 'package:Dividex/shared/widgets/custom_form_wrapper.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/layout.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final ValueNotifier<CurrencyEnum> selectedCurrency = ValueNotifier(
    CurrencyEnum.vnd,
  );
  List<CurrencyEnum> get units => CurrencyEnum.values;
  List<Uint8List> updatedImages = [];
  List<ImageModel> deletedImages = [];

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    selectedCurrency.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return AppShell(
      currentIndex: 3,
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state.user is UserModel && state.user != null) {
            final user = state.user as UserModel;
            name.text = user.fullName ?? '';
            email.text = user.email ?? '';
            phone.text = user.phoneNumber ?? '';
            selectedCurrency.value = user.currency ?? CurrencyEnum.vnd;

            return SimpleLayout(
              title: intl.profileSetting,
              child: CustomFormWrapper(
                fields: [
                  FormFieldConfig(controller: name, isRequired: true),
                  FormFieldConfig(
                    selectedValue: selectedCurrency,
                    isRequired: true,
                  ),
                ],
                builder: (valid) => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    BlocProvider(
                      create: (context) => ImageBloc(),
                      child: BlocBuilder<ImageBloc, ImageState>(
                        builder: (context, state) {
                          return ImageUpdateDeleteWidget(
                            label: intl.profilePicture,
                            nameForExampleImage: user.fullName ?? '',
                            isAvatar: true,
                            type: PickerType.avatar,
                            images: user.avatar != null ? [user.avatar!] : [],
                            onFilesPicked: (List<Uint8List> files) {
                              updatedImages = [files[0]];
                            },
                            onDelete: (image) {
                              deletedImages = [image];
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomTextInputWidget(
                      size: TextInputSize.large,
                      controller: name,
                      keyboardType: TextInputType.text,
                      isReadOnly: false,
                      isRequired: true,
                      label: intl.nameLabel,
                    ),
                    const SizedBox(height: 16),
                    CustomTextInputWidget(
                      size: TextInputSize.large,
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      isReadOnly: true,
                      isRequired: true,
                      label: intl.emailLabel,
                    ),
                    const SizedBox(height: 16),
                    CustomTextInputWidget(
                      size: TextInputSize.large,
                      controller: phone,
                      keyboardType: TextInputType.phone,
                      isReadOnly: true,
                      isRequired: false,
                      label: intl.phoneLabel,
                    ),
                    const SizedBox(height: 16),
                    CustomTextInputWidget(
                      size: TextInputSize.large,
                      controller: TextEditingController(text: selectedCurrency.value.code.toUpperCase()),
                      keyboardType: TextInputType.text,
                      isReadOnly: true,
                      isRequired: false,
                      label: intl.expenseCurrencyLabel,
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: intl.save,
                      size: ButtonSize.large,
                      onPressed: valid
                          ? () {
                              context.read<UserBloc>().add(
                                UpdateMeEvent(
                                  name: name.text,
                                  currency: selectedCurrency.value,
                                  avatar: updatedImages.isNotEmpty
                                      ? updatedImages[0]
                                      : null,
                                  deletedAvatarUid: deletedImages.isNotEmpty
                                      ? deletedImages[0].uid
                                      : null,
                                ),
                              );
                            }
                          : null,
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(
            child: const SpinKitFadingCircle(color: AppThemes.primary3Color),
          );
        },
      ),
    );
  }
}
