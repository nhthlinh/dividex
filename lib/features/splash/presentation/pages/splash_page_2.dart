import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/wave_painter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage2 extends StatelessWidget {
  const SplashPage2({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); 
    final intl = AppLocalizations.of(context)!; 

    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: CustomPaint(painter: WavePainter()),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 32.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 30),

                    Image.asset(
                      'lib/assets/images/splash_image.png',
                      width: 280,
                      height: 330,
                    ),
                    const SizedBox(height: 23),

                    // Title
                    Text(
                      intl.createAccountPrompt,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 12),

                    // Subtitle
                    Text(
                      intl.splashPage2Subtitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppThemes.borderColor,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Sign up button
                    CustomButton(
                      text: intl.register,
                      onPressed: () {
                        context.pushNamed(AppRouteNames.register);
                      },
                    ),
                    const SizedBox(height: 12),

                    // Log in button
                    CustomButton(
                      type: ButtonType.secondary,
                      text: intl.login, 
                      onPressed: () {
                        context.pushNamed(AppRouteNames.login);
                      }
                    ),
                    const SizedBox(height: 24),

                    // Terms and privacy
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppThemes.borderColor,
                        ),
                        children: [
                          TextSpan(text: intl.acceptancePrompt),
                          TextSpan(
                            text: intl.termsOfServiceLink,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppThemes.primary3Color,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.pushNamed(AppRouteNames.termOfUse);
                              },
                          ),
                          TextSpan(text: intl.andConjunction),
                          TextSpan(
                            text: intl.privacyPolicyLink,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppThemes.primary3Color,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.pushNamed(AppRouteNames.termOfUse);
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
