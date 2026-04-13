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
import 'package:Dividex/shared/widgets/custom_form_wrapper.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
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
  static const Key pageKey = Key('profile_page');
  static const Key avatarWidgetKey = Key('profile_avatar_widget');
  static const Key nameInputKey = Key('profile_name_input');
  static const Key saveButtonKey = Key('profile_save_button');

  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  // final ValueNotifier<CurrencyEnum> selectedCurrency = ValueNotifier(
  //   CurrencyEnum.vnd,
  // );
  List<CurrencyEnum> get units => CurrencyEnum.values;
  List<Uint8List> updatedImages = [];
  List<ImageModel> deletedImages = [];

  final clearFormTrigger = ValueNotifier(false);

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    //selectedCurrency.dispose();
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
            //selectedCurrency.value = user.currency ?? CurrencyEnum.vnd;

            return SimpleLayout(
              key: pageKey,
              onRefresh: () {
                clearFormTrigger.value =
                    !clearFormTrigger.value; // Trigger form reset
                context.read<UserBloc>().add(GetMeEvent());
                return Future.value();
              },
              title: intl.profileSetting,
              child: CustomFormWrapper(
                clearTrigger: clearFormTrigger,
                fields: [
                  FormFieldConfig(controller: name, isRequired: true),
                  // FormFieldConfig(
                  //   selectedValue: selectedCurrency,
                  //   isRequired: true,
                  // ),
                ],
                builder: (isValid, isSubmitting, setSubmitting) => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    BlocProvider(
                      create: (context) => ImageBloc(),
                      child: BlocBuilder<ImageBloc, ImageState>(
                        builder: (context, state) {
                          return ImageUpdateDeleteWidget(
                            key: avatarWidgetKey,
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
                      textFieldKey: nameInputKey,
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
                    // CustomTextInputWidget(
                    //   size: TextInputSize.large,
                    //   controller: TextEditingController(
                    //     text: selectedCurrency.value.code.toUpperCase(),
                    //   ),
                    //   keyboardType: TextInputType.text,
                    //   isReadOnly: true,
                    //   isRequired: false,
                    //   label: intl.expenseCurrencyLabel,
                    // ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: intl.save,
                      buttonKey: saveButtonKey,
                      size: ButtonSize.large,

                      onPressed: (!isValid || isSubmitting)
                          ? null
                          : () async {
                              setSubmitting(true);

                              context.read<UserBloc>().add(
                                UpdateMeEvent(
                                  name: name.text,
                                  currency: CurrencyEnum.vnd,
                                  avatar: updatedImages.isNotEmpty
                                      ? updatedImages[0]
                                      : null,
                                  deletedAvatarUid: deletedImages.isNotEmpty
                                      ? deletedImages[0].uid
                                      : null,
                                ),
                              );

                              setSubmitting(false);
                            },
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
