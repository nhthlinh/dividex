// import 'package:Dividex/config/l10n/app_localizations.dart';
// import 'package:Dividex/config/location/locale_cubit.dart';
// import 'package:Dividex/config/routes/router.dart';
// import 'package:Dividex/config/themes/theme_cubit.dart';
// import 'package:Dividex/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:Dividex/features/auth/presentation/bloc/auth_event.dart';
// import 'package:Dividex/shared/widgets/custom_button.dart';
// import 'package:Dividex/shared/widgets/show_dialog_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

// class SettingsSheet extends StatelessWidget {
//   final String userId;
//   const SettingsSheet({super.key, required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final intl = AppLocalizations.of(context)!; // Get the localization instance

//     return Container(
//       width: MediaQuery.of(context).size.width * 0.7, // Adjust height as needed
//       height:
//           MediaQuery.of(context).size.height, // Adjust height as needed
//       decoration: BoxDecoration(
//         color: theme.scaffoldBackgroundColor, // Use theme's background color
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 const SizedBox(height: 15),
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.arrow_back),
//                       onPressed: () {
//                         Navigator.pop(context); // Close the sheet
//                       },
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       'Menu', // "Setting"
//                       style: theme.textTheme.titleMedium, // Adjust text style
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const Divider(height: 1), // Optional divider
//           _buildSettingsOption(
//             context,
//             intl.profileSetting, // "Profile"
//             () {
//               //context.pushNamed(AppRouteNames.profile);
//             },
//           ),
//           _buildSettingsOption(
//             context,
//             intl.settingLanguage, // "Language"
//             () {
//               showCustomDialog(
//                 context: context,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       intl.settingChooseLanguage,
//                       style: theme.textTheme.titleMedium,
//                     ), // "Select Language"
//                     const SizedBox(height: 16),
//                     ListTile(
//                       title: Text(
//                         intl.settingChooseEng,
//                       ), // "English"
//                       onTap: () {
//                         final localeBloc = context.read<LocaleCubit>();
//                         localeBloc.changeLocale('en');
//                         // close the dialog after selection
//                         Navigator.pop(context); // Close the dialog
//                       },
//                     ),
//                     ListTile(
//                       title: Text(
//                         intl.settingChooseVie,
//                       ), // "Vietnamese"
//                       onTap: () {
//                         final localeBloc = context.read<LocaleCubit>();
//                         localeBloc.changeLocale(
//                           'vi',
//                         ); // Handle Vietnamese selection
//                         // close the dialog after selection
//                         Navigator.pop(context); // Close the dialog
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//           _buildSettingsOption(context, intl.settingTheme, () {
//             showCustomDialog(
//               context: context,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     intl.settingChooseTheme,
//                     style: theme.textTheme.titleMedium,
//                   ),
//                   const SizedBox(height: 16),
//                   ListTile(
//                     title: Text(
//                       intl.settingChooseDark,
//                     ), // "English"
//                     onTap: () {
//                       final themeBloc = context.read<ThemeCubit>();
//                       themeBloc.setThemeFromString(
//                         'dark',
//                       ); // Handle dark theme selection
//                       // close the dialog after selection
//                       Navigator.pop(context); // Close the dialog
//                     },
//                   ),
//                   ListTile(
//                     title: Text(intl.settingChooseLight),
//                     onTap: () {
//                       final themeBloc = context.read<ThemeCubit>();
//                       themeBloc.setThemeFromString(
//                         'light',
//                       ); // Handle light theme selection
//                       // close the dialog after selection
//                       Navigator.pop(context); // Close the dialog
//                     },
//                   ),
//                 ],
//               ),
//             );
//           }),
//           _buildSettingsOption(
//             context,
//             intl.settingTerm, // "Term of use"
//             () {
//               context.pushNamed(AppRouteNames.termOfUse);
//             },
//           ),
//           _buildSettingsOption(
//             context,
//             intl.settingSecurity, // "Security" (Typo in image: "Sercurity")
//             () {
//               showCustomDialog(
//                 context: context,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       intl.securitySettings, // "Security Settings"
//                       style: theme.textTheme.titleMedium,
//                     ),
//                     const SizedBox(height: 16),
//                     ListTile(
//                       title: Text(
//                         intl.settingChangePass,
//                       ),
//                       onTap: () {
//                         context.pushNamed(AppRouteNames.changePass);
//                       },
//                     ),
//                     // Thêm các tùy chọn bảo mật khác nếu cần
//                   ],
//                 ),
//               );
//             },
//           ),

//           const Spacer(), // Pushes the sign out button to the bottom
//           Center(
//             child: CustomButton(
//               buttonText: intl.signOut,
//               onPressed: () {
//                 final authBloc = context.read<AuthBloc>();
//                 authBloc.add(const AuthLogoutRequested());
//                 context.goNamed(AppRouteNames.login);
//               },
//               isBig: false,
//             ),
//           ),
//           const SizedBox(height: 50),
//         ],
//       ),
//     );
//   }

//   Widget _buildSettingsOption(
//     BuildContext context,
//     String title,
//     VoidCallback onTap, {
//     String? subtitle,
//   }) {
//     final theme = Theme.of(context);
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   title,
//                   style: theme.textTheme.titleSmall, // Adjust text style
//                 ),
//                 const Icon(Icons.arrow_forward_ios, size: 16),
//               ],
//             ),
//             if (subtitle != null) ...[
//               const SizedBox(height: 4),
//               Text(
//                 subtitle,
//                 style: theme.textTheme.bodySmall?.copyWith(
//                   color: Colors.grey,
//                 ), // Adjust subtitle style
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/location/locale_cubit.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/config/themes/theme_cubit.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_event.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/layout.dart';
import 'package:Dividex/shared/widgets/show_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return AppShell(
      currentIndex: 3,
      child: Layout(
        title: intl.settings,
        showAvatar: true,
        avatarUrl: HiveService.getUser().avatarUrl != '' ? HiveService.getUser().avatarUrl : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(HiveService.getUser().fullName ?? 'User')}&background=random&color=fff&size=128',
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

            settingOption(
              intl.settingChangePass,
              context,
              onTap: () {
                context.pushNamed(AppRouteNames.changePass);
              },
            ),
            settingOption(
              intl.settingTheme,
              context,
              onTap: () {
                showCustomDialog(
                  context: context,
                  label: intl.settingChooseTheme,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      settingOption(
                        intl.settingChooseDark, context,
                        onTap: () { 
                          final themeBloc = context.read<ThemeCubit>();
                          themeBloc.setThemeFromString(
                            'dark',
                          ); // Handle dark theme selection
                          // close the dialog after selection
                          Navigator.pop(context); // Close the dialog
                        },
                      ),
                      settingOption(
                        intl.settingChooseLight, context,
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
            settingOption(
              intl.settingLanguage,
              context,
              onTap: () {
                showCustomDialog(
                  context: context,
                  label: intl.settingChooseLanguage,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      settingOption(
                        intl.settingChooseEng, context,
                        onTap: () { 
                          final localeBloc = context.read<LocaleCubit>();
                          localeBloc.changeLocale('en');
                          // close the dialog after selection
                          Navigator.pop(context); // Close the dialog
                        },
                      ),
                      settingOption(
                        intl.settingChooseVie, context,
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
            settingOption(
              intl.settingTerm,
              context,
              onTap: () {
                context.pushNamed(AppRouteNames.termOfUse);
              },
            ),
            settingOption(
              intl.profileSetting,
              context,
              onTap: () {
                // Handle profile action
              },
            ),
            settingOption(
              intl.qrCode,
              context,
              onTap: () {
                // Handle QR code scanning action
              },
            ),

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
