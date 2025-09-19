import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Dividex/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(const AuthCheckRequested()); // chỉ chạy 1 lần
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          current is AuthAuthenticated || current is AuthUnauthenticated,
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.goNamed(AppRouteNames.home);
        } else if (state is AuthUnauthenticated) {
          context.goNamed(AppRouteNames.splash2);
        }
      },
      child: const Scaffold(
        body: Center(
          child: Image(
            image: AssetImage('lib/assets/images/Logo_no_background.png'),
            width: 500,
            height: 500,
          ),
        ),
      ),
    );
  }
}
