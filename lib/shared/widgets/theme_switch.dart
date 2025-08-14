import 'package:Dividex/config/themes/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final List<ThemeMode> modes = [
          ThemeMode.light,
          ThemeMode.dark,
          ThemeMode.system,
        ];

        final Map<ThemeMode, IconData> modeIcons = {
          ThemeMode.light: Icons.light_mode,
          ThemeMode.dark: Icons.dark_mode,
          ThemeMode.system: Icons.brightness_auto,
        };

        return IconButton(
          icon: Icon(modeIcons[themeMode]!),
          onPressed: () {
            final nextMode = modes[(modes.indexOf(themeMode) + 1) % modes.length];
            context.read<ThemeCubit>().setTheme(nextMode);
          },
        );
      },
    );
  }
}
