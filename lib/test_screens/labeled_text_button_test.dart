import 'package:Dividex/shared/widgets/text_button.dart';
import 'package:flutter/material.dart';

class LabeledTextButtonTestPage extends StatelessWidget {
  const LabeledTextButtonTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test LabeledTextButton")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Case 1: Có description + nút mặc định"),
            CustomTextButton(
              description: "Mô tả:",
              label: "Xem chi tiết",
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Bấm nút Xem chi tiết")),
                );
              },
            ),
            const Divider(),

            const Text("Case 2: Không có description"),
            CustomTextButton(
              label: "Chỉ có nút",
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Bấm nút Chỉ có nút")),
                );
              },
            ),
            const Divider(),

            const Text("Case 3: Đổi màu nút"),
            CustomTextButton(
              description: "Trạng thái:",
              label: "Đặc biệt",
              textColor: Colors.red,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Bấm nút Đặc biệt")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
