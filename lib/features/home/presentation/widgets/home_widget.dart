import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/features/event_expense/data/models/expense_model.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  // Giả sử bạn có một danh sách các giao dịch
  List<ExpenseModel> transactions = [];

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
              child: Column(
                children: [
                  CustomButton(
                    buttonText: intl.addGroup,
                    onPressed: () {
                      context.pushNamed(AppRouteNames.addGroup);
                    },
                    isBig: false,
                  ),
                ],
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
          title: Text(transaction.totalAmount.toString()),
          subtitle: Text(transaction.toString()),
        );
      },
    );
  }
}

// // Thay thế với các models và enums của bạn
// // import 'package:Dividex/features/event_expense/data/models/expense_model.dart'; 
// // import 'package:Dividex/shared/widgets/custom_button.dart';
// // import 'package:Dividex/config/l10n/app_localizations.dart';

// class HomeWidget extends StatefulWidget {
//   const HomeWidget({super.key});

//   @override
//   State<HomeWidget> createState() => _HomeWidgetState();
// }

// class _HomeWidgetState extends State<HomeWidget> {
//   // Dữ liệu giả định để minh họa
//   // Thay thế bằng dữ liệu thực tế từ API/database của bạn
//   final double totalOwe = 250000;
//   final double totalOwedByOthers = 124000;
//   final List<Map<String, dynamic>> recentTransactions = [
//     {
//       "name": "Ngân Anh",
//       "amount": 24000,
//       "isOwedByYou": false, // Nợ bạn
//       "avatar": Icons.person,
//     },
//     {
//       "name": "Nguyễn Đặng Minh Anh",
//       "amount": 24000,
//       "isOwedByYou": true, // Bạn nợ
//       "avatar": Icons.person,
//     },
//     {
//       "name": "Home",
//       "amount": 24000,
//       "isOwedByYou": true, // Bạn nợ
//       "avatar": Icons.person,
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     // final intl = AppLocalizations.of(context)!; // Sử dụng i18n
//     final theme = Theme.of(context);

//     return Container(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           _buildBalanceCard(theme),
//           const SizedBox(height: 24),
//           Expanded(child: _buildRecentTransactionsSection(theme)),
//         ],
//       ),
//     );
//   }

//   Widget _buildBalanceCard(ThemeData theme) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _buildBalanceItem(
//                   theme,
//                   "Bạn nợ",
//                   totalOwe,
//                   Colors.red,
//                   Icons.arrow_forward,
//                 ),
//                 _buildBalanceItem(
//                   theme,
//                   "Nợ bạn",
//                   totalOwedByOthers,
//                   Colors.green,
//                   Icons.arrow_back,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBalanceItem(ThemeData theme, String title, double amount, Color color, IconData icon) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(title, style: theme.textTheme.bodyMedium),
//         const SizedBox(height: 4),
//         Row(
//           children: [
//             Icon(icon, color: color, size: 20),
//             const SizedBox(width: 8),
//             Text(
//               "${_formatCurrency(amount)} ₫",
//               style: theme.textTheme.titleSmall!.copyWith(color: color, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildRecentTransactionsSection(ThemeData theme) {
//     final intl = AppLocalizations.of(context)!;

//     if (recentTransactions.isEmpty) {
//       return Center(
//         child: Column(
//           children: [
//             Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
//             const SizedBox(height: 16),
//             Text(intl.noTransaction, style: theme.textTheme.titleSmall),
//             const SizedBox(height: 8),
//             Text(intl.addFirstTransaction, style: theme.textTheme.bodySmall!.copyWith(color: Colors.grey)),
//           ],
//         ),
//       );
//     }
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Giao dịch gần đây",
//           style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 16),
//         ...recentTransactions.map((transaction) {
//           return _buildTransactionItem(theme, transaction);
//         }),
//       ],
//     );
//   }

//   Widget _buildTransactionItem(ThemeData theme, Map<String, dynamic> transaction) {
//     final bool isOwedByYou = transaction["isOwedByYou"] as bool;
//     final Color amountColor = isOwedByYou ? Colors.red : Colors.green;
//     final String amountText = isOwedByYou ? "Bạn nợ" : "Nợ bạn";

//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       margin: const EdgeInsets.only(bottom: 12),
//       child: ListTile(
//         contentPadding: const EdgeInsets.all(12),
//         leading: CircleAvatar(
//           backgroundColor: Colors.grey[200],
//           child: Icon(transaction["avatar"] as IconData, color: Colors.grey[600]),
//         ),
//         title: Text(
//           transaction["name"] as String,
//           style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
//         ),
//         trailing: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text(
//               amountText,
//               style: theme.textTheme.bodySmall!.copyWith(color: Colors.grey),
//             ),
//             Text(
//               "${_formatCurrency(transaction["amount"] as double)} ₫",
//               style: theme.textTheme.bodyMedium!.copyWith(color: amountColor, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String _formatCurrency(double amount) {
//     // Định dạng tiền tệ đơn giản, bạn có thể sử dụng intl package
//     return amount.toStringAsFixed(0).replaceAllMapped(
//       RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
//       (Match m) => '${m[1]}.',
//     );
//   }
// }
