import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/event_expense/data/models/user_debt.dart';
import 'package:Dividex/features/event_expense/presentation/widgets/toggle_tap.dart';
import 'package:Dividex/features/event_expense/presentation/widgets/user_amount_table.dart';
import 'package:Dividex/features/event_expense/presentation/widgets/user_item_table.dart';
import 'package:Dividex/features/image/data/models/image_expense_model.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/utils/num.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplitPage extends StatefulWidget {
  final String eventId;
  final LoadType type;
  final List<UserDebt> initialSelected;
  final List<UserModel> initialUsers;
  final SplitTypeEnum initialType;
  final double amount;
  final Function(List<UserDebt> value) onChanged;
  final List<ImageExpenseItemModel> items;

  const SplitPage({
    super.key,
    required this.eventId,
    required this.type,
    required this.initialSelected,
    required this.initialUsers,
    required this.initialType,
    required this.amount,
    required this.onChanged,
    required this.items
  });

  @override
  State<SplitPage> createState() => _SplitPageState();
}

class _SplitPageState extends State<SplitPage> {
  List<UserDebt> _currentDebts = [];
  bool isCustomByAmount = true;


  @override
  void initState() {
    super.initState();
    _currentDebts = widget.initialSelected;
  }

  void _onUsersChanged(List<UserDebt> debts) {
    setState(() {
      _currentDebts = debts;
    });
    widget.onChanged(_currentDebts);
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return AppShell(
      currentIndex: 0,
      child: SimpleLayout(
        onRefresh: () {
          // Reset về giá trị ban đầu
          setState(() {
            _currentDebts = widget.initialSelected;
          });
          return Future.value();
        },
        title: intl.expenseSplitCustomLabel,
        child: Column(
          children: [
            // --- Header total ---
            Container(
              width: 340,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TestInGrey(text: intl.totalAmount),
                      Text(
                        formatNumber(widget.amount),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppThemes.primary3Color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ToggleTab(
                    initialValue: isCustomByAmount,
                    onChanged: (value) {
                      setState(() {
                        if (value == false && widget.items != []) {
                          isCustomByAmount = false;
                        } 
                        isCustomByAmount = true;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Divider(),
                ],
              ),
            ),

            if (isCustomByAmount) ...[
              // --- Table ---
              UserTableWidget(
                usersDebt: _currentDebts,
                users: widget.initialUsers,
                totalAmount: widget.amount,
                onChanged: _onUsersChanged,
              ),
            ] else if (widget.items != []) ...[
              UserItemTableWidget(
                usersDebt: _currentDebts,
                users: widget.initialUsers,
                totalAmount: widget.amount,
                onChanged: _onUsersChanged,
                items: []
              ),
            ],

            const SizedBox(height: 16),

            CustomButton(
              text: intl.accept,
              onPressed: () {
                context.pop(_currentDebts);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TestInGrey extends StatelessWidget {
  const TestInGrey({super.key, required this.text, this.fontSize = 14});

  final String text;
  final int fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontSize: fontSize.toDouble(),
        color: Colors.grey,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
