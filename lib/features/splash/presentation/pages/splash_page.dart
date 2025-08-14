import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          current is AuthAuthenticated || current is AuthUnauthenticated,
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.goNamed(AppRouteNames.home);
        } else if (state is AuthUnauthenticated) {
          context.goNamed(AppRouteNames.login);
        }
      },
      child: Builder(
        builder: (context) {
          // Gửi sự kiện kiểm tra mỗi khi widget được build lại
          context.read<AuthBloc>().add(const AuthCheckRequested());

          return const Scaffold(
            body: Center(
              child: Image(
                image: AssetImage('lib/assets/images/Logo_no_background.png'), 
                width: 500,
                height: 500,
              ),
            ),
          );
        },
      ),
    );
  }
}
