import 'package:Dividex/shared/widgets/layout.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Welcome Back",
      child: const Text("This is the Sign In Page"),
    );
  }
}
