import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/event_expense/data/models/expense_approve_model.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_bloc.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_event.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_state.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/utils/change_string.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/content_card.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/info_card.dart';
import 'package:Dividex/shared/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ExpenseApprovePage extends StatefulWidget {
  final String expenseId;
  final String actionType;

  const ExpenseApprovePage({super.key, required this.expenseId, required this.actionType});

  @override
  State<ExpenseApprovePage> createState() => _ExpenseApprovePageState();
}

class _ExpenseApprovePageState extends State<ExpenseApprovePage> {
  bool _showAllPending = false;

  @override
  void initState() {
    super.initState();
    // Trigger both events separately
    context.read<ExpenseBloc>().add(
      GetExpenseApproveEvent(expenseId: widget.expenseId, actionType: widget.actionType),
    );
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AppShell(
      currentIndex: 0,
      child: Layout(
        onRefresh: () async {
          context.read<ExpenseBloc>().add(
            GetExpenseApproveEvent(expenseId: widget.expenseId, actionType: widget.actionType),
          );
          return Future.value();
        },
        title: intl.expense,
        child: BlocBuilder<ExpenseBloc, ExpenseState>(
          builder: (context, state) {
            if (state is! GetExpenseApproveState) {
              return Center(
                child: ColoredBox(
                  color: Colors.transparent,
                  child: SpinKitFadingCircle(color: AppThemes.primary3Color),
                ),
              );
            }
            final ExpenseApprovalModel expense = state.expenseApprove;

            final accepted = expense.acceptedUsers;

            final declined = expense.declinedUsers;

            final pending = expense.pendingUsers;

            final total = expense.totalMembers ?? 0;

            double progress = total == 0 ? 0 : expense.acceptedCount! / total;

            final String? myId = HiveService.getUser().id;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// notification
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppThemes.primary3Color.withOpacity(.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.assignment_add,
                        color: AppThemes.primary3Color,
                      ),
                    ),

                    SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            intl.newExpenseApprovalRequest,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 4),

                          Text(
                            intl.expenseApprovalDescription,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8),

                /// expense detail
                InfoCard(
                  onTap: () {
                    context.pushNamed(
                      AppRouteNames.expenseDetail,
                      pathParameters: {"id": widget.expenseId},
                    );
                  },

                  title: intl.expenseDetails,

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        intl.viewDetails,
                        style: TextStyle(
                          color: AppThemes.primary3Color,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(width: 4),

                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 12,
                        color: AppThemes.primary3Color,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 8),

                /// approval status
                _buildCard(
                  title: intl.approvalStatus,
                  rightWidget: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppThemes.successColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      intl.approvedCount(expense.acceptedCount!, total),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppThemes.successColor,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: progress,
                        borderRadius: BorderRadius.circular(20),
                        minHeight: 8,
                      ),

                      SizedBox(height: 4),

                      Text(
                        intl.needMoreApprovals(
                          ((total / 2).ceil()) - expense.acceptedCount!,
                        ),
                        style: theme.textTheme.bodySmall,
                      ),

                      Divider(),

                      _statusSection(
                        intl.accepted,
                        accepted ?? [],
                        expense.acceptedCount ?? 0,
                        AppThemes.successColor,
                        Icons.check_circle,
                      ),

                      Divider(),

                      _statusSection(
                        intl.declined,
                        declined ?? [],
                        expense.declinedCount ?? 0,
                        AppThemes.errorColor,
                        Icons.cancel,
                      ),

                      Divider(),

                      _statusSection(
                        intl.pending,
                        pending ?? [],
                        expense.pendingCount ?? 0,
                        AppThemes.warningColor,
                        Icons.help,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 8),

                /// expire card
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 40,
                        color: AppThemes.primary3Color,
                      ),

                      SizedBox(width: 12),

                      Expanded(child: Text(intl.requestExpireMessage)),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                if (myId != null &&
                    pending != null &&
                    pending.any((e) => e.uid == myId))
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: intl.decline,
                          size: ButtonSize.medium,
                          type: ButtonType.secondary,
                          customColor: AppThemes.errorColor,
                          onPressed: () {
                            context.read<ExpenseBloc>().add(
                              VoteOnExpenseEvent(
                                expenseId: widget.expenseId,
                                action: "DECLINED",
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(width: 12),

                      Expanded(
                        child: CustomButton(
                          text: intl.approve,
                          size: ButtonSize.medium,
                          customColor: AppThemes.successColor,
                          onPressed: () {
                            context.read<ExpenseBloc>().add(
                              VoteOnExpenseEvent(
                                expenseId: widget.expenseId,
                                action: "ACCEPTED",
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                SizedBox(height: 30),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required Widget child,
    Widget? rightWidget,
  }) {
    return ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              Spacer(),
              if (rightWidget != null) rightWidget,
            ],
          ),
          SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _statusSection(
    String title,
    List<ApprovalUserModel> users,
    int total,
    Color color,
    IconData icon,
  ) {
    final intl = AppLocalizations.of(context)!;
    const int previewCount = 4;

    final displayedUsers = !_showAllPending && users.length > previewCount
        ? users.take(previewCount).toList()
        : users;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),

            Expanded(
              child: Text(
                "$title ($total)",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),

            if (users.length > previewCount)
              InkWell(
                onTap: () {
                  setState(() {
                    _showAllPending = !_showAllPending;
                  });
                },
                child: Row(
                  children: [
                    Text(
                      _showAllPending ? intl.showLess : intl.showMore,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppThemes.primary3Color,
                      ),
                    ),

                    Icon(
                      _showAllPending ? Icons.expand_less : Icons.expand_more,
                      size: 18,
                      color: AppThemes.primary3Color,
                    ),
                  ],
                ),
              ),
          ],
        ),

        const SizedBox(height: 12),

        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: displayedUsers.map((e) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.grey,
                    backgroundImage:
                        (e.avatar?.publicUrl != null &&
                            e.avatar!.publicUrl.isNotEmpty)
                        ? NetworkImage(e.avatar!.publicUrl)
                        : NetworkImage(
                            'https://ui-avatars.com/api/?name=${Uri.encodeComponent(e.fullName ?? '')}&background=random&color=fff&size=128',
                          ),
                  ),

                  const SizedBox(width: 8),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        getLastTwoWords(e.fullName ?? ''),
                        style: const TextStyle(fontSize: 13),
                      ),

                      Text(
                        e.votedAt != null
                            ? DateFormat('hh:mm a').format(e.votedAt!)
                            : '--',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
