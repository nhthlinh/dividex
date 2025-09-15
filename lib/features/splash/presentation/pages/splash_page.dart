import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_dropdown_widget.dart';
import 'package:Dividex/test_screens/custom_button_test.dart';
import 'package:Dividex/test_screens/custom_dropdown_test.dart';
import 'package:Dividex/test_screens/labeled_text_button_test.dart';
import 'package:Dividex/test_screens/show_dialog_test.dart';
import 'package:Dividex/test_screens/test_card_page.dart';
import 'package:Dividex/test_screens/upload_image_test.dart';
import 'package:Dividex/test_screens/custom_input_test.dart';
import 'package:flutter/material.dart';

// class SplashPage extends StatelessWidget {
//   const SplashPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthBloc, AuthState>(
//       listenWhen: (previous, current) =>
//           current is AuthAuthenticated || current is AuthUnauthenticated,
//       listener: (context, state) {
//         if (state is AuthAuthenticated) {
//           context.goNamed(AppRouteNames.home);
//         } else if (state is AuthUnauthenticated) {
//           context.goNamed(AppRouteNames.login);
//         }
//       },
//       child: Builder(
//         builder: (context) {
//           // Gửi sự kiện kiểm tra mỗi khi widget được build lại
//           context.read<AuthBloc>().add(const AuthCheckRequested());

//           return const Scaffold(
//             body: Center(
//               child: Image(
//                 image: AssetImage('lib/assets/images/Logo_no_background.png'),
//                 width: 500,
//                 height: 500,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// } // nhớ import file CustomButton bạn viết

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return const TestCardScreen();
  }
}
