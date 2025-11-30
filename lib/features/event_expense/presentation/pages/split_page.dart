import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/event_expense/data/models/user_debt.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/content_card.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:Dividex/shared/widgets/text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class SplitPage extends StatefulWidget {
  final String eventId;
  final LoadType type;
  final List<UserDebt> initialSelected;
  final List<UserModel> initialUsers;
  final SplitTypeEnum initialType;
  final double amount;
  final Function(List<UserDebt> value) onChanged;

  const SplitPage({
    super.key,
    required this.eventId,
    required this.type,
    required this.initialSelected,
    required this.initialUsers,
    required this.initialType,
    required this.amount,
    required this.onChanged,
  });

  @override
  State<SplitPage> createState() => _SplitPageState();
}

class _SplitPageState extends State<SplitPage> {
  List<UserDebt> _currentDebts = [];

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
                        widget.amount.toStringAsFixed(0),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppThemes.primary3Color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Divider(),
                ],
              ),
            ),

            // --- Table ---
            UserTableWidget(
              usersDebt: _currentDebts,
              users: widget.initialUsers,
              totalAmount: widget.amount,
              onChanged: _onUsersChanged,
            ),

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

class UserShare {
  final UserModel? user;
  double amount;
  double percent;
  bool selected;

  UserShare({
    required this.user,
    required this.amount,
    required this.percent,
    this.selected = false,
  });
}

class UserTableWidget extends StatefulWidget {
  final List<UserModel> users;
  final List<UserDebt> usersDebt;
  final double totalAmount;
  final ValueChanged<List<UserDebt>> onChanged;

  const UserTableWidget({
    super.key,
    required this.users,
    required this.usersDebt,
    required this.totalAmount,
    required this.onChanged,
  });

  @override
  State<UserTableWidget> createState() => _UserTableWidgetState();
}

class _UserTableWidgetState extends State<UserTableWidget> {
  late List<UserShare> users;
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    users = widget.users.map((user) {
      return UserShare(user: user, amount: 0, percent: 0);
    }).toList();

    // Map từ initial UserDebt
    for (var debt in widget.usersDebt) {
      final u = users.firstWhere(
        (x) => x.user?.id == debt.userId,
        orElse: () => UserShare(user: null, amount: 0, percent: 0),
      );
      if (u.user != null) {
        u.selected = true;
        u.amount = debt.amount;
        u.percent = (widget.totalAmount > 0)
            ? (debt.amount / widget.totalAmount) * 100
            : 0;
      }
    }

    _controllers.addAll(
      List.generate(
        users.length,
        (index) =>
            TextEditingController(text: users[index].amount.toStringAsFixed(0)),
      ),
    );
  }

  void _recalculate(int index) {
    // tổng số tiền user nhập
    final totalEntered = users
        .where((u) => u.selected)
        .fold<double>(0, (sum, u) => sum + u.amount);

    if (totalEntered > widget.totalAmount) {
      // nếu tổng số tiền nhập lớn hơn tổng số tiền thì reset lại giá trị của user hiện tại
      setState(() {
        _controllers[index].text = '1';

        users[index].selected = true;
        users[index].amount = 1;
        users[index].percent = (widget.totalAmount > 0)
            ? (1 / widget.totalAmount) * 100
            : 0;
      });
      return;
    }

    for (final u in users) {
      if (u.selected) {
        if (totalEntered > 0) {
          u.percent = (u.amount / widget.totalAmount) * 100;
        } else {
          u.percent = 0;
        }
      } else {
        u.amount = 0;
        u.percent = 0;
      }
    }

    // gọi notify parent
    _notifyParent();
  }

  void reset() {
    for (final u in users) {
      u.selected = true;
      u.amount = widget.totalAmount / users.length;
      u.percent = 100 / users.length;
    }
    for (var controller in _controllers) {
      controller.text = (widget.totalAmount / users.length).toStringAsFixed(0);
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

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          color: Colors.transparent,
          child: Row(
            children: [
              Expanded(flex: 3, child: TestInGrey(text: intl.user)),
              Expanded(flex: 2, child: TestInGrey(text: intl.amount)),
              Expanded(
                flex: 2,
                child: Center(child: TestInGrey(text: "%")),
              ),
              const SizedBox(width: 40),
            ],
          ),
        ),

        // Rows
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return _buildUserRow(user, index);
          },
        ),

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
                  TestInGrey(text: intl.allocated),
                  Text(
                    '${users.where((u) => u.selected).fold<double>(0, (sum, u) => sum + u.amount).toStringAsFixed(0)}/${widget.totalAmount.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppThemes.primary3Color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  ContentCard _buildUserRow(UserShare user, int index) {
    return ContentCard(
      color: user.selected
          ? Theme.of(context).scaffoldBackgroundColor
          : Colors.grey[200],
      onTap: () {
        setState(() {
          user.selected = !user.selected;
          if (!user.selected) {
            user.amount = 0;
            user.percent = 0;
          } else {
            user.amount = 1;
            user.percent = (widget.totalAmount > 0)
                ? (1 / widget.totalAmount) * 100
                : 0;
          }
          _controllers[index].text = user.amount.toStringAsFixed(0);
        });
        _recalculate(index);
      },
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey,
                  backgroundImage:
                      (user.user!.avatar != null &&
                          user.user!.avatar!.publicUrl.isNotEmpty)
                      ? NetworkImage(user.user!.avatar!.publicUrl)
                      : NetworkImage(
                          'https://ui-avatars.com/api/?name=${Uri.encodeComponent(user.user!.fullName ?? 'User')}&background=random&color=fff&size=128',
                        ),
                ),
                const SizedBox(width: 8),
                Text(
                  (user.user?.fullName != null &&
                          user.user!.fullName!.trim().isNotEmpty)
                      ? user.user!.fullName!.trim().split(' ').last
                      : '',
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 2,
            child: CustomTextInputWidget(
              size: TextInputSize.small,
              controller: _controllers[index],
              keyboardType: TextInputType.number,
              isReadOnly: !user.selected,
              onChanged: (value) {
                setState(() {
                  final entered = double.tryParse(value) ?? 0;
                  user.amount = entered;
                });
                _recalculate(index);
              },
            ),
            // Text(
            //   user.amount.toStringAsFixed(0),
            //   style: const TextStyle(
            //     fontWeight: FontWeight.bold,
            //     color: AppThemes.minusMoney,
            //   ),
            // ),
          ),

          const SizedBox(width: 4),
          Expanded(
            flex: 2,
            child: Center(child: Text(user.percent.toStringAsFixed(2))),
          ),
          SizedBox(
            width: 40,
            child: Icon(
              user.selected ? Icons.check_box : Icons.check_box_outline_blank,
              color: user.selected ? AppThemes.primary3Color : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
