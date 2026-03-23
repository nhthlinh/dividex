import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/event_expense/data/models/user_debt.dart';
import 'package:Dividex/features/event_expense/presentation/pages/split_page.dart';
import 'package:Dividex/features/image/data/models/image_expense_model.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/shared/utils/num.dart';
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
    required this.items,
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
    required this.items,
  });

  @override
  State<UserItemTableWidget> createState() => _UserItemTableWidgetState();
}

class _UserItemTableWidgetState extends State<UserItemTableWidget> {
  late List<UserItemShare> users;
  Map<int, List<int>> itemUserMap = {};
  bool isSelectingItems = true;
  List<bool> isExpanded = [];

  @override
  void initState() {
    super.initState();
    isExpanded = List.filled(widget.items.length, false);

    users = widget.users.map((user) {
      return UserItemShare(user: user, amount: 0, percent: 0, items: []);
    }).toList();

    // Map từ initial UserDebt
    for (var debt in widget.usersDebt) {
      final u = users.firstWhere(
        (x) => x.user?.id == debt.userId,
        orElse: () =>
            UserItemShare(user: null, amount: 0, percent: 0, items: []),
      );
      if (u.user != null) {
        u.selected = true;
        u.amount = debt.amount;
        u.percent = (widget.totalAmount > 0)
            ? (debt.amount / widget.totalAmount) * 100
            : 0;
      }
    }
    _calculateFromItems();
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

  // void _calculateFromItems() {
  //   // reset
  //   for (var u in users) {
  //     u.amount = 0;
  //     u.items = [];
  //     u.selected = false;
  //   }

  //   for (int i = 0; i < widget.items.length; i++) {
  //     final item = widget.items[i];
  //     final selectedUsers = itemUserMap[i] ?? [];

  //     if (selectedUsers.isEmpty) continue;

  //     final share = item.totalPrice / selectedUsers.length;

  //     for (var userIndex in selectedUsers) {
  //       final user = users[userIndex];
  //       user.amount += share;
  //       user.selected = true;
  //       user.items.add(item);
  //     }
  //   }

  //   // tính percent
  //   for (var u in users) {
  //     u.percent = widget.totalAmount > 0
  //         ? (u.amount / widget.totalAmount) * 100
  //         : 0;
  //   }
  // }
  double _delta = 0;

  void _calculateFromItems() {
    // reset
    for (var u in users) {
      u.amount = 0;
      u.items = [];
      u.selected = false;
    }

    double itemsTotal = 0;

    // 1. Chia theo item
    for (int i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];
      final selectedUsers = itemUserMap[i] ?? [];

      if (selectedUsers.isEmpty) continue;

      final share = item.totalPrice / selectedUsers.length;
      itemsTotal += item.totalPrice;

      for (var userIndex in selectedUsers) {
        final user = users[userIndex];
        user.amount += share;
        user.selected = true;
        user.items.add(item);
      }
    }

    // 2. Tính phần chênh lệch (tax / discount)
    _delta = widget.totalAmount - itemsTotal;

    // 3. Tổng tiền user đang có (trước khi cộng delta)
    double currentTotal = users.fold(0, (sum, u) => sum + u.amount);

    if (currentTotal > 0 && _delta != 0) {
      // 4. Phân bổ delta theo tỷ lệ
      for (var u in users) {
        final ratio = u.amount / currentTotal;
        u.amount += _delta * ratio;
      }
    }

    // 5. Tính percent
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

  Widget _buildAdjustmentInfo(AppLocalizations intl) {
    final isExtra = _delta > 0;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Icon(
            isExtra ? Icons.add_circle_outline : Icons.remove_circle_outline,
            size: 16,
            color: isExtra ? Colors.orange : Colors.green,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              isExtra
                  ? intl.addFee
                  : intl.disFee,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
          Text(
            formatNumber(_delta.abs()),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isExtra ? Colors.orange : Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Rows
        if (isSelectingItems)
          _buildItemSelection(intl)
        else ...[
          _buildUserSummary(),
          if (_delta != 0) _buildAdjustmentInfo(intl),
        ],

        Container(
          width: 340,
          margin: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              if (!isSelectingItems)
                CustomTextButton(label: intl.reset, onPressed: reset),
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
                      icon: Icon(Icons.navigate_before),
                    ),
                  TestInGrey(text: intl.allocated),
                  Text(
                    '${formatNumber(users.where((u) => u.selected).fold<double>(0, (sum, u) => sum + u.amount))}/${formatNumber(widget.totalAmount)}',
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
                      icon: Icon(Icons.navigate_next),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String formatName(String name) {
    if (name.length <= 25) return name;
    return '${name.substring(0, 10)}...${name.substring(name.length - 10)}';
  }

  Widget _buildItemSelection(AppLocalizations intl) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.items.length,
      itemBuilder: (context, itemIndex) {
        final item = widget.items[itemIndex];
        final selectedUsers = itemUserMap[itemIndex] ?? [];

        return InkWell(
          child: Container(
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
                    Expanded(
                      child: Row(
                        children: [
                          // quantity + name
                          Expanded(
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: [
                                  TextSpan(
                                    text: 'x${item.quantity.toInt()} ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          color: AppThemes.primary3Color,
                                        ),
                                  ),
                                  TextSpan(
                                    text: formatName(item.name),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // price
                          Text(
                            formatNumber(item.totalPrice),
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(color: AppThemes.primary3Color),
                          ),
                        ],
                      ),
                    ),
                    // icon up/down
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isExpanded[itemIndex] = !isExpanded[itemIndex];
                        });
                      },
                      icon: Icon(
                        isExpanded[itemIndex]
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 24,
                      ),
                    ),
                  ],
                ),

                if (isExpanded[itemIndex]) ...[
                  // List user chọn
                  ...List.generate(users.length, (userIndex) {
                    final user = users[userIndex];
                    final isChecked = selectedUsers.contains(userIndex);

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      // Avatar
                      leading: CircleAvatar(
                        radius: 18,
                        backgroundImage:
                            (user.user!.avatar != null &&
                                user.user!.avatar!.publicUrl.isNotEmpty)
                            ? NetworkImage(user.user!.avatar!.publicUrl)
                            : NetworkImage(
                                'https://ui-avatars.com/api/?name=${Uri.encodeComponent(user.user!.fullName ?? 'User')}&background=random&color=fff',
                              ),
                      ),
                      title: Text(
                        user.user!.fullName ?? '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isChecked
                              ? AppThemes.primary3Color
                              : Colors.grey.shade800,
                        ),
                      ),
                      trailing: Icon(
                        isChecked ? Icons.check : Icons.check_box_outline_blank,
                        color: isChecked
                            ? AppThemes.primary3Color
                            : Colors.grey,
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
                  }),
                ] else if (!isExpanded[itemIndex] &&
                    (itemUserMap[itemIndex] ?? []).isEmpty) ...[
                  SizedBox.shrink(),
                ] else ...[
                  SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: (itemUserMap[itemIndex] ?? []).map((userIndex) {
                        final user = users[userIndex];

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                (user.user!.avatar != null &&
                                    user.user!.avatar!.publicUrl.isNotEmpty)
                                ? NetworkImage(user.user!.avatar!.publicUrl)
                                : NetworkImage(
                                    'https://ui-avatars.com/api/?name=${Uri.encodeComponent(user.user!.fullName ?? 'User')}&background=random&color=fff',
                                  ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserSummary() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: users.length,
      itemBuilder: (context, index) {
        return _buildUserRow(users[index], index);
      },
    );
  }

  Widget _buildUserRow(UserItemShare user, int index) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
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
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(height: 4),

                // Amount (đỏ giống hình)
                Text(
                  formatNumber(user.amount),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppThemes.primary3Color,
                  ),
                ),

                const SizedBox(height: 4),

                // Items text
                if (user.items.isNotEmpty)
                  Text(
                    _buildItemsText(user.items),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
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
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
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
              user.selected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: user.selected ? AppThemes.primary3Color : Colors.grey,
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
