import 'package:Dividex/config/location/locale_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageButton extends StatelessWidget {
  const LanguageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.language),
      tooltip: 'Change Language',
      onPressed: () {
        final currentLocale = context.read<LocaleCubit>().state;

        if (currentLocale.languageCode == 'en') {
          context.read<LocaleCubit>().changeLocale('vi');
        } else {
          context.read<LocaleCubit>().changeLocale('en');
        }
      },
    );
  }
}
