import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  // Giả sử bạn có một danh sách các giao dịch
  List<String> transactions = [];

  @override
  void initState() {
    super.initState();
    // Giả sử bạn có một danh sách các giao dịch
    transactions = [];
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              intl.noTransaction,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: 8),
            Text(
              intl.addFirstTransaction,
              style: Theme.of(
                context,
              ).textTheme.bodySmall!.copyWith(color: Colors.grey),
            ),
            SizedBox(height: 16),
            Center(
              child: CustomButton(
                buttonText: intl.addGroup,
                onPressed: () {
                  // Handle add transaction
                },
                isBig: false,
              ),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return ListTile(
          title: Text(transaction),
          subtitle: Text(transaction.toString()),
        );
      },
    );
  }
}
