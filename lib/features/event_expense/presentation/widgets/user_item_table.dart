
import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/event_expense/data/models/user_debt.dart';
import 'package:Dividex/features/event_expense/presentation/pages/split_page.dart';
import 'package:Dividex/features/image/data/models/image_expense_model.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/shared/widgets/text_button.dart';
import 'package:flutter/material.dart';


class UserItemShare {
  final UserModel? user;
  double amount;
  double percent;
  bool selected;
  List<ImageExpenseItemModel> items;

  UserItemShare({
    required this.user,
    required this.amount,
    required this.percent,
    this.selected = false,
    required this.items
  });
}


class UserItemTableWidget extends StatefulWidget {
  final List<UserModel> users;
  final List<UserDebt> usersDebt;
  final double totalAmount;
  final ValueChanged<List<UserDebt>> onChanged;
  final List<ImageExpenseItemModel> items; 

  const UserItemTableWidget({
    super.key,
    required this.users,
    required this.usersDebt,
    required this.totalAmount,
    required this.onChanged,
    required this.items
  });

  @override
  State<UserItemTableWidget> createState() => _UserItemTableWidgetState();
}

class _UserItemTableWidgetState extends State<UserItemTableWidget> {
  late List<UserItemShare> users;
  Map<int, List<int>> itemUserMap = {};
  bool isSelectingItems = true;

  @override
  void initState() {
    super.initState();
    users = widget.users.map((user) {
      return UserItemShare(user: user, amount: 0, percent: 0, items: []);
    }).toList();

    // Map từ initial UserDebt
    for (var debt in widget.usersDebt) {
      final u = users.firstWhere(
        (x) => x.user?.id == debt.userId,
        orElse: () => UserItemShare(user: null, amount: 0, percent: 0, items: []),
      );
      if (u.user != null) {
        u.selected = true;
        u.amount = debt.amount;
        u.percent = (widget.totalAmount > 0)
            ? (debt.amount / widget.totalAmount) * 100
            : 0;
      }
    }
  }

  void reset() {
    for (final u in users) {
      u.selected = true;
      u.amount = widget.totalAmount / users.length;
      u.percent = 100 / users.length;
      u.items = [];
    }
    _notifyParent();
  }

  void _notifyParent() {
    final debts = users
        .where((u) => u.selected)
        .map((u) => UserDebt(userId: u.user!.id!, amount: u.amount))
        .toList();
    widget.onChanged(debts);
  }

  void _calculateFromItems() {
    // reset
    for (var u in users) {
      u.amount = 0;
      u.items = [];
      u.selected = false;
    }

    for (int i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];
      final selectedUsers = itemUserMap[i] ?? [];

      if (selectedUsers.isEmpty) continue;

      final share = item.totalPrice / selectedUsers.length;

      for (var userIndex in selectedUsers) {
        final user = users[userIndex];
        user.amount += share;
        user.selected = true;
        user.items.add(item);
      }
    }

    // tính percent
    for (var u in users) {
      u.percent = widget.totalAmount > 0
          ? (u.amount / widget.totalAmount) * 100
          : 0;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Rows
        if (isSelectingItems)
          _buildItemSelection()
        else
          _buildUserSummary(),

        const SizedBox(height: 16),

        Container(
          width: 340,
          margin: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              CustomTextButton(
                label: intl.expenseSplitEquallyLabel,
                onPressed: reset,
              ),
              const SizedBox(height: 8),
              Divider(),

              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!isSelectingItems)
                    IconButton(
                      onPressed: () {
                        setState(() => isSelectingItems = true);
                      }, 
                      icon: Icon(Icons.navigate_next)
                    ),
                  TestInGrey(text: intl.allocated),
                  Text(
                    '${users.where((u) => u.selected).fold<double>(0, (sum, u) => sum + u.amount).toStringAsFixed(0)}/${widget.totalAmount.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppThemes.primary3Color,
                    ),
                  ),
                  if (isSelectingItems)
                    IconButton(
                      onPressed: () {
                        _calculateFromItems();
                        setState(() => isSelectingItems = false);
                        _notifyParent(); 
                      }, 
                      icon: Icon(Icons.navigate_next)
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemSelection() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: widget.items.length,
      itemBuilder: (context, itemIndex) {
        final item = widget.items[itemIndex];
        final selectedUsers = itemUserMap[itemIndex] ?? [];

        return Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              // Header item
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'x${item.quantity} ${item.name}',
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    item.totalPrice.toStringAsFixed(0),
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // List user chọn
              ...List.generate(users.length, (userIndex) {
                final user = users[userIndex];
                final isChecked = selectedUsers.contains(userIndex);

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      user.user!.avatar?.publicUrl ?? '',
                    ),
                  ),
                  title: Text(user.user!.fullName ?? ''),
                  trailing: Icon(
                    isChecked
                        ? Icons.check
                        : Icons.check_box_outline_blank,
                    color: isChecked ? Colors.red : Colors.grey,
                  ),
                  onTap: () {
                    setState(() {
                      final list = itemUserMap[itemIndex] ?? [];
                      if (list.contains(userIndex)) {
                        list.remove(userIndex);
                      } else {
                        list.add(userIndex);
                      }
                      itemUserMap[itemIndex] = list;
                    });
                  },
                );
              })
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserSummary() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: users.length,
      itemBuilder: (context, index) {
        return _buildUserRow(users[index], index);
      },
    );
  }

  Widget _buildUserRow(UserItemShare user, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: user.selected ? Colors.white : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 22,
            backgroundImage:
                (user.user!.avatar != null &&
                        user.user!.avatar!.publicUrl.isNotEmpty)
                    ? NetworkImage(user.user!.avatar!.publicUrl)
                    : NetworkImage(
                        'https://ui-avatars.com/api/?name=${Uri.encodeComponent(user.user!.fullName ?? 'User')}&background=random&color=fff',
                      ),
          ),

          const SizedBox(width: 12),

          // Name + amount + items
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  user.user!.fullName ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                // Amount (đỏ giống hình)
                Text(
                  user.amount.toStringAsFixed(0),
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                // Items text
                Text(
                  _buildItemsText(user.items),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Percent
          Column(
            children: [
              Text(
                user.percent.toStringAsFixed(1),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(width: 8),

          // Checkbox
          GestureDetector(
            onTap: () {
              setState(() {
                user.selected = !user.selected;
                if (!user.selected) {
                  user.amount = 0;
                  user.percent = 0;
                }
              });
              //_recalculate(index);
            },
            child: Icon(
              user.selected
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: user.selected ? Colors.redAccent : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  String _buildItemsText(List<ImageExpenseItemModel> items) {
    if (items.isEmpty) return '';

    final text = items.map((e) => e.name).join(', ');

    if (text.length <= 20) return text;

    return '${text.substring(0, 20)}...';
  }
}
