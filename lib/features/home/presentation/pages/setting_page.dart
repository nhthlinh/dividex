import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/location/locale_cubit.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/config/themes/theme_cubit.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_event.dart';
import 'package:Dividex/features/user/presentation/bloc/user_bloc.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart';
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_form_wrapper.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/layout.dart';
import 'package:Dividex/shared/widgets/show_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final oldPin = TextEditingController();
  final newPin = TextEditingController();
  final confirmNewPin = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final clearFormTrigger = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return AppShell(
      currentIndex: 3,
      child: Layout(
        onRefresh: () {
          clearFormTrigger.value = !clearFormTrigger.value; // Trigger form reset
          return Future.value();
        },
        title: intl.settings,
        showAvatar: true,
        avatarUrl: HiveService.getUser().avatarUrl?.publicUrl != ''
            ? HiveService.getUser().avatarUrl?.publicUrl
            : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(HiveService.getUser().fullName ?? 'User')}&background=random&color=fff&size=128',
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            children: [
              Center(
                child: Text(
                  HiveService.getUser().fullName ?? '',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppThemes.primary3Color,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              SettingOption(
                label: intl.settingChangePass,
                context: context,
                onTap: () {
                  context.pushNamed(AppRouteNames.changePass);
                },
              ),
              SettingOption(
                label: intl.settingTheme,
                context: context,
                onTap: () {
                  showCustomDialog(
                    context: context,
                    label: intl.settingChooseTheme,
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SettingOption(
                          label: intl.settingChooseDark,
                          context: context,
                          onTap: () {
                            final themeBloc = context.read<ThemeCubit>();
                            themeBloc.setThemeFromString(
                              'dark',
                            ); // Handle dark theme selection
                            // close the dialog after selection
                            Navigator.pop(context); // Close the dialog
                          },
                        ),
                        SettingOption(
                          label: intl.settingChooseLight,
                          context: context,
                          onTap: () {
                            final themeBloc = context.read<ThemeCubit>();
                            themeBloc.setThemeFromString(
                              'light',
                            ); // Handle light theme selection
                            // close the dialog after selection
                            Navigator.pop(context); // Close the dialog
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              SettingOption(
                label: intl.settingLanguage,
                context: context,
                onTap: () {
                  showCustomDialog(
                    context: context,
                    label: intl.settingChooseLanguage,
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SettingOption(
                          label: intl.settingChooseEng,
                          context: context,
                          onTap: () {
                            final localeBloc = context.read<LocaleCubit>();
                            localeBloc.changeLocale('en');
                            // close the dialog after selection
                            Navigator.pop(context); // Close the dialog
                          },
                        ),
                        SettingOption(
                          label: intl.settingChooseVie,
                          context: context,
                          onTap: () {
                            final localeBloc = context.read<LocaleCubit>();
                            localeBloc.changeLocale(
                              'vi',
                            ); // Handle Vietnamese selection
                            // close the dialog after selection
                            Navigator.pop(context); // Close the dialog
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              SettingOption(
                label: intl.settingTerm,
                context: context,
                onTap: () {
                  context.pushNamed(AppRouteNames.termOfUse);
                },
              ),
              SettingOption(
                label: intl.profileSetting,
                context: context,
                onTap: () {
                  context.pushNamed(AppRouteNames.profile);
                },
              ),
              SettingOption(
                label: intl.rechargeIntoApp,
                context: context,
                onTap: () {
                  context.pushNamed(AppRouteNames.recharge);
                },
              ),
              SettingOption(
                label: intl.updatePin,
                context: context,
                onTap: () {
                  showCustomDialog(
                    context: context,
                    content: CustomFormWrapper(
                      clearTrigger: clearFormTrigger,
                      formKey: _formKey,
                      fields: [
                        FormFieldConfig(controller: oldPin, isRequired: true),
                        FormFieldConfig(controller: newPin, isRequired: true),
                        FormFieldConfig(
                          controller: confirmNewPin,
                          isRequired: true,
                        ),
                      ],
                      builder: (valid) => Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            intl.updatePinGuide,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppThemes.primary3Color,
                                ),
                          ),
                          const SizedBox(height: 16),
                          CustomTextInputWidget(
                            label: intl.currentPin,
                            size: TextInputSize.large,
                            controller: oldPin,
                            keyboardType: TextInputType.number,
                            isReadOnly: false,
                            isRequired: true,
                            validator: (value) =>
                                CustomValidator().validatePin(value, intl),
                          ),
                          const SizedBox(height: 16),
                          CustomTextInputWidget(
                            label: intl.newPin,
                            size: TextInputSize.large,
                            controller: newPin,
                            keyboardType: TextInputType.number,
                            isReadOnly: false,
                            isRequired: true,
                            validator: (value) =>
                                CustomValidator().validatePin(value, intl),
                          ),
                          const SizedBox(height: 16),
                          CustomTextInputWidget(
                            label: intl.confirmPin,
                            size: TextInputSize.large,
                            controller: confirmNewPin,
                            keyboardType: TextInputType.number,
                            isReadOnly: false,
                            isRequired: true,
                            validator: (value) => CustomValidator()
                                .validateConfirmPassword(value, intl, newPin),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: CustomButton(
                              text: intl.save,
                              onPressed: valid
                                  ? () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<UserBloc>().add(
                                          UpdatePinEvent(
                                            oldPin: oldPin.text,
                                            newPin: newPin.text,
                                          ),
                                        );
                                      }
                                    }
                                  : null,
                              size: ButtonSize.medium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const Spacer(),

              Center(
                child: CustomButton(
                  text: intl.signOut,
                  onPressed: () {
                    final authBloc = context.read<AuthBloc>();
                    authBloc.add(const AuthLogoutRequested());
                    context.goNamed(AppRouteNames.splash2);
                  },
                  customColor: AppThemes.errorColor,
                  size: ButtonSize.medium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingOption extends StatelessWidget {
  const SettingOption({
    super.key,
    required this.label,
    required this.context,
    required this.onTap,
  });

  final String label;
  final BuildContext context;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
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
