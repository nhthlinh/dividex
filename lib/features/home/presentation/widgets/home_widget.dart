import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/features/friend/data/models/friend_request_model.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_state.dart';
import 'package:Dividex/features/home/presentation/widgets/format.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/presentation/bloc/user_bloc.dart';
import 'package:Dividex/features/user/presentation/bloc/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final double totalOwe = 250000;
  final double totalOwedByOthers = 124000;
  final List<FriendRequestModel> recentTransactions = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final intl = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildBalanceCard(theme),
            const SizedBox(height: 24),
            BlocBuilder<LoadedFriendsBloc, LoadedFriendsState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state.requests.isEmpty) {
                  if (recentTransactions.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.receipt_long,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            intl.noTransaction,
                            style: theme.textTheme.titleSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            intl.addFirstTransaction,
                            style: theme.textTheme.bodySmall!.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }

                recentTransactions.clear();
                recentTransactions.addAll(state.requests);
                return _buildRecentTransactionsSection(theme);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(ThemeData theme) {
    final intl = AppLocalizations.of(context)!;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBalanceItem(
                  theme,
                  intl.youOwn,
                  totalOwe,
                  Colors.red,
                  Icons.arrow_forward,
                ),
                _buildBalanceItem(
                  theme,
                  intl.ownYou,
                  totalOwedByOthers,
                  Colors.green,
                  Icons.arrow_back,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceItem(
    ThemeData theme,
    String title,
    double amount,
    Color color,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              "${formatCurrency(amount)} ₫",
              style: theme.textTheme.titleSmall!.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentTransactionsSection(ThemeData theme) {
    final intl = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          intl.recentTransaction,
          style: theme.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...recentTransactions.map((transaction) {
          return _buildTransactionItem(theme, transaction);
        }),
      ],
    );
  }

  Widget _buildTransactionItem(
    ThemeData theme,
    FriendRequestModel transaction,
  ) {
    final intl = AppLocalizations.of(context)!;
    final bool isOwedByYou = transaction.hasDebt ?? false;
    final Color amountColor = isOwedByYou ? Colors.red : Colors.green;
    final String amountText = isOwedByYou ? intl.youOwn : intl.ownYou;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(transaction.avatarUrl),
          child: Icon(
            Icons.person,
            color: Colors.grey[600],
          ),
        ),
        title: Text(
          transaction.fullName,
          style: theme.textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              amountText,
              style: theme.textTheme.bodySmall!.copyWith(color: Colors.grey),
            ),
            Text(
              "${formatCurrency(transaction.amount ?? 0.0)} ₫",
              style: theme.textTheme.bodyMedium!.copyWith(
                color: amountColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
