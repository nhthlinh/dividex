import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/event_expense/data/models/user_debt.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/event/event_event.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_bloc.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_event.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_state.dart';
import 'package:Dividex/features/image/presentation/pages/image_page.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/info_card.dart';
import 'package:Dividex/shared/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class ExpenseDetail extends StatefulWidget {
  final String expenseId;

  const ExpenseDetail({super.key, required this.expenseId});

  @override
  State<ExpenseDetail> createState() => _ExpenseDetailState();
}

class _ExpenseDetailState extends State<ExpenseDetail> {
  @override
  void initState() {
    super.initState();

    context.read<ExpenseBloc>().add(
      GetExpenseDetail(expenseId: widget.expenseId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AppShell(
      currentIndex: 0,
      child: Layout(
        title: intl.expense,
        child: BlocBuilder<ExpenseBloc, ExpenseState>(
          builder: (context, state) {
            if (state is! ExpenseLoadedState) {
              return Center(
                child: ColoredBox(
                  color: Colors.transparent,
                  child: SpinKitFadingCircle(color: AppThemes.primary3Color),
                ),
              );
            }
            final expense = state.expense;

            // Format thành chuỗi mong muốn
            final formatted = DateFormat(
              "h:mm a - dd/MM/yyyy",
            ).format(expense.expenseDate!);
            final formattedReminder = DateFormat(
              "dd/MM/yyyy",
            ).format(expense.remindAt ?? DateTime.now());

            print('expense userDebtInfos: ${expense.userDebtInfos?.map((e) => e.amount).toList()}');
            print('expense userDebts: ${expense.userDebtInfos?.map((e) => e.user.fullName).toList()}');
            print('expense userDebtInfos: ${expense.userDebtInfos?.map((e) => e.user.avatar).toList()}');

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            expense.name ?? '',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: AppThemes.primary3Color,
                            ),
                          ),
                          Text(
                            formatted,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "%",
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppThemes.infoColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AppThemes.borderColor),
                  const SizedBox(height: 16),
                  buildGroupInfoRow(
                    intl.amount,
                    expense.totalAmount.toString() +
                        (expense.currency?.code ?? ''),
                  ),
                  buildGroupInfoRow(
                    intl.expenseCategoryLabel,
                    expense.category ?? '',
                  ),
                  buildGroupInfoRow(intl.expensePayerLabel, expense.paidByUser?.fullName ?? ''),
                  buildGroupInfoRow(intl.dueDay, formattedReminder),

                  const SizedBox(height: 16),
              
                  //Image
                  Text(
                    intl.image,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (expense.images != null && expense.images!.isNotEmpty) ...[
                    SizedBox(
                      height: 200,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: expense.images?.length ?? 0,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final image = expense.images![index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImagePage(
                                    imageBytes: null,
                                    imageUrl: image.publicUrl,
                                  ),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                image.publicUrl,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 200,
                                    height: 200,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.broken_image),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ] else ...[
                    SizedBox.shrink()
                  ],

                  const SizedBox(height: 16),
              
                  Text(
                    intl.billDetail,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
              
                  if (expense.userDebtInfos != null &&
                      expense.userDebtInfos!.isNotEmpty) ...[
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: expense.userDebtInfos?.length ?? 0,
                      itemBuilder: (context, index) {
                        final userDebt = expense.userDebtInfos![index];
                        try {
                          return ExpenseCard(
                            expense: userDebt,
                            totalAmount: expense.totalAmount ?? 1,
                            currency: expense.currency?.code ?? '',
                          );
                        } catch (e) {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ],
              
                  const SizedBox(height: 8),
              
                  Text(
                    intl.expenseNoteLabel,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    expense.note ?? '',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
              
                  // actions
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildGroupInfoRow(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppThemes.borderColor, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: AppThemes.primary3Color),
          ),
        ],
      ),
    );
  }
}

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({
    super.key,
    required this.expense,
    required this.totalAmount,
    required this.currency,
  });

  final UserDeptInfo expense;
  final double totalAmount;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      title: expense.user.fullName ?? '',
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey,
        backgroundImage:
            (expense.user.avatar?.publicUrl != null &&
                expense.user.avatar!.publicUrl.isNotEmpty)
            ? NetworkImage(expense.user.avatar!.publicUrl)
            : NetworkImage(
                'https://ui-avatars.com/api/?name=${Uri.encodeComponent(expense.user.fullName ?? '')}&background=random&color=fff&size=128',
              ),
      ),
      subtitle: (expense.amount >= 0)
          ? '${(expense.amount / totalAmount * 100).toStringAsFixed(2)} %'
          : '0 %',
      trailing: Column(
        children: [
          Text(
            (expense.amount >= 0
                ? '+ ${expense.amount} $currency'
                : '- ${expense.amount.abs()} $currency'),
            style: TextStyle(
              color: (expense.amount >= 0)
                  ? AppThemes.successColor
                  : AppThemes.minusMoney,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          // Text(
          //   expense.status == ExpenseStatus.done ? intl.done : intl.notYet,
          //   style: Theme.of(context).textTheme.bodySmall?.copyWith(
          //     color: expense.status == ExpenseStatus.done
          //         ? AppThemes.successColor
          //         : AppThemes.minusMoney,
          //   ),
          // ),
        ],
      ),
    );
  }
}
