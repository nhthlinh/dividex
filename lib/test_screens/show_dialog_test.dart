import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/show_dialog_widget.dart';
import 'package:flutter/material.dart';

class DialogTestPage extends StatelessWidget {
  const DialogTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test Custom Dialog")),
      body: Center(
        child: CustomButton(
          text: "Mở Dialog",
          size: ButtonSize.medium,
          customColor: Colors.blue,
          onPressed: () {
            showCustomDialog(
              context: context,
              label: "Xác nhận hành động",
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Đây là nội dung test dialog."),
                  SizedBox(height: 8),
                  Text("Bạn có muốn tiếp tục không?"),
                ],
              ),
              actions: [
                CustomButton(
                  text: "Hủy",
                  size: ButtonSize.medium,
                  customColor: Colors.grey,
                  type: ButtonType.secondary,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CustomButton(
                  text: "Đồng ý",
                  size: ButtonSize.medium,
                  customColor: Colors.blue,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Đã chọn Đồng ý!")),
                    );
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
