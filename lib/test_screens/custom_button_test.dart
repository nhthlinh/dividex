import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class CustomButtonTest extends StatelessWidget {
  const CustomButtonTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test CustomButton")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "👉 Primary (no customColor)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            CustomButton(
              text: "Primary Large",
              size: ButtonSize.large,
              type: ButtonType.primary,
              onPressed: () => debugPrint("Primary Large clicked"),
            ),
            const SizedBox(height: 8),
            CustomButton(
              text: "Primary Medium",
              size: ButtonSize.medium,
              type: ButtonType.primary,
              onPressed: () => debugPrint("Primary Medium clicked"),
            ),
            const SizedBox(height: 8),
            CustomButton(
              text: "Primary Small Disabled",
              size: ButtonSize.small,
              type: ButtonType.primary,
              onPressed: null,
            ),

            const SizedBox(height: 24),
            const Text(
              "👉 Secondary (no customColor)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            CustomButton(
              text: "Secondary Large",
              size: ButtonSize.large,
              type: ButtonType.secondary,
              onPressed: () => debugPrint("Secondary Large clicked"),
            ),
            const SizedBox(height: 8),
            CustomButton(
              text: "Secondary Medium Disabled",
              size: ButtonSize.medium,
              type: ButtonType.secondary,
              onPressed: null,
            ),

            const SizedBox(height: 24),
            const Text(
              "👉 Primary (with customColor)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            CustomButton(
              text: "Primary Large Custom",
              size: ButtonSize.large,
              type: ButtonType.primary,
              customColor: Colors.deepOrange,
              onPressed: () => debugPrint("Primary Large Custom clicked"),
            ),
            const SizedBox(height: 8),
            CustomButton(
              text: "Primary Medium Custom Disabled",
              size: ButtonSize.medium,
              type: ButtonType.primary,
              customColor: Colors.deepOrange,
              onPressed: null,
            ),

            const SizedBox(height: 24),
            const Text(
              "👉 Secondary (with customColor)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            CustomButton(
              text: "Secondary Large Custom",
              size: ButtonSize.large,
              type: ButtonType.secondary,
              customColor: Colors.green,
              onPressed: () => debugPrint("Secondary Large Custom clicked"),
            ),
            const SizedBox(height: 8),
            CustomButton(
              text: "Secondary Small Custom Disabled",
              size: ButtonSize.small,
              type: ButtonType.secondary,
              customColor: Colors.green,
              onPressed: null,
            ),
          ],
        ),
      ),
    );
  }
}
