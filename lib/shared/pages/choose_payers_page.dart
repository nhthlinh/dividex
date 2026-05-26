import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/event_expense/data/models/payer_model.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/shared/bloc/load_user_bloc.dart';
import 'package:Dividex/shared/bloc/load_user_event.dart';
import 'package:Dividex/shared/bloc/load_user_state.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/utils/change_string.dart';
import 'package:Dividex/shared/utils/num.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/info_card.dart';
import 'package:Dividex/shared/widgets/show_dialog_widget.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class ChoosePayersPage extends StatefulWidget {
  final String? id;
  final LoadType type;
  final List<PayerModel>? initialSelectedPayers;
  final double totalAmount;
  final bool isMultiSelect;
  final bool isCanChooseMyself;

  const ChoosePayersPage({
    super.key,
    required this.type,
    required this.totalAmount,
    required this.initialSelectedPayers,
    required this.id,
    required this.isMultiSelect,
    this.isCanChooseMyself = false,
  });

  @override
  State<ChoosePayersPage> createState() => _ChoosePayersPageState();
}

class _ChoosePayersPageState extends State<ChoosePayersPage> {
  static const Key searchInputKey = Key('choose_payer_search_input');
  static const Key searchButtonKey = Key('choose_payer_search_button');

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final List<PayerModel> _selectedPayers = []; // <-- lưu payer đã chọn

  double get _selectedTotal {
    return _selectedPayers.fold(0, (sum, e) => sum + (e.amount ?? 0));
  }

  bool get _canConfirm {
    return (_selectedTotal - widget.totalAmount).abs() < 0.01;
  }

  @override
  void initState() {
    super.initState();
    _selectedPayers.addAll(widget.initialSelectedPayers ?? []);
    context.read<LoadedUsersBloc>().add(InitialEvent(widget.id, widget.type));
  }

  void _togglePayer(PayerModel payer) {
    setState(() {
      if (!widget.isMultiSelect) {
        _selectedPayers.clear();
      }

      final index = _selectedPayers.indexWhere(
        (p) => p.user.id == payer.user.id,
      );

      if (index != -1) {
        _selectedPayers.removeAt(index);
      } else {
        _selectedPayers.add(payer);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AppShell(
      currentIndex: 0,
      child: SimpleLayout(
        onRefresh: () {
          _selectedPayers.addAll(widget.initialSelectedPayers ?? []);
          context.read<LoadedUsersBloc>().add(
            InitialEvent(widget.id, widget.type),
          );
          return Future.value();
        },
        title: intl.addMembers,
        child: Column(
          children: [
            // Search
            CustomTextInputWidget(
              size: TextInputSize.large,
              isReadOnly: false,
              keyboardType: TextInputType.text,
              label: intl.searchTab,
              controller: _searchController,
              textFieldKey: searchInputKey,
              suffixIcon: IconButton(
                key: searchButtonKey,
                onPressed: () {
                  context.read<LoadedUsersBloc>().add(
                    InitialEvent(
                      widget.id,
                      widget.type,
                      searchQuery: _searchController.text,
                    ),
                  );
                },
                icon: Icon(Icons.search),
              ),
            ),

            // results
            BlocBuilder<LoadedUsersBloc, LoadedUsersState>(
              buildWhen: (p, c) =>
                  p.users != c.users || p.isLoading != c.isLoading,
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(
                    child: ColoredBox(
                      color: Colors.transparent,
                      child: SpinKitFadingCircle(
                        color: AppThemes.primary3Color,
                      ),
                    ),
                  );
                } else if (state.users.isEmpty) {
                  return noUserWidget(intl, theme);
                }

                final hasMore = state.users.length < state.totalItems;
                final String myId = HiveService.getUser().id ?? '';
                final usersWithoutMyself = state.users
                    .where((user) => user.id != myId)
                    .toList();

                return listResults(
                  intl,
                  hasMore,
                  state.totalItems,
                  widget.isCanChooseMyself ? state.users : usersWithoutMyself,
                  state.page,
                );
              },
            ),

            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(intl.amountLabel, style: theme.textTheme.bodySmall),

                  Text(
                    "${formatNumber(_selectedTotal)} / ${formatNumber(widget.totalAmount)}",
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: _canConfirm
                          ? AppThemes.successColor
                          : AppThemes.errorColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            CustomButton(
              text: intl.confirm,
              size: ButtonSize.large,
              customColor: _canConfirm ? AppThemes.primary3Color : Colors.grey,

              onPressed: _canConfirm
                  ? () {
                      context.pop(_selectedPayers);
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  LayoutBuilder noUserWidget(AppLocalizations intl, ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Icon(Icons.no_accounts, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(intl.noSearchResults, style: theme.textTheme.titleSmall),
            ],
          ),
        );
      },
    );
  }

  Column listResults(
    AppLocalizations intl,
    bool hasMore,
    int totalUsers,
    List<UserModel>? users,
    int page,
  ) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: intl.result,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 12,
                letterSpacing: 0,
                height: 16 / 12,
                color: Colors.grey,
              ),
              children: totalUsers > 0
                  ? [
                      TextSpan(
                        text: totalUsers > 99
                            ? ' 99+'
                            : ' ${widget.isCanChooseMyself ? totalUsers : totalUsers - 1}',
                        style: TextStyle(color: AppThemes.primary3Color),
                      ),
                    ]
                  : [],
            ),
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: users?.length != null
              ? (users!.length + (hasMore ? 1 : 0))
              : 0,
          itemBuilder: (context, index) {
            if (index == users!.length) {
              context.read<LoadedUsersBloc>().add(
                LoadMoreUsersEvent(
                  page + 1,
                  widget.id,
                  widget.type,
                  searchQuery: _searchController.text.isEmpty
                      ? null
                      : _searchController.text,
                ),
              );
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: SpinKitFadingCircle(color: AppThemes.primary3Color),
                ),
              );
            }

            final user = users[index];
            final isSelected = _selectedPayers.any((p) => p.user.id == user.id);
            final selectedPayerIndex = _selectedPayers.indexWhere(
              (p) => p.user.id == user.id,
            );
            final selectedPayer = selectedPayerIndex != -1
                ? _selectedPayers[selectedPayerIndex]
                : null;

            return InfoCard(
              title: getLastTwoWords(user.fullName),
              subtitle: selectedPayer?.amount != null
                  ? formatNumber(selectedPayer!.amount)
                  : null,
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                backgroundImage:
                    (user.avatar != null && user.avatar!.publicUrl.isNotEmpty)
                    ? NetworkImage(user.avatar!.publicUrl)
                    : NetworkImage(
                        'https://ui-avatars.com/api/?name=${Uri.encodeComponent(user.fullName ?? 'User')}&background=random&color=fff&size=128',
                      ),
              ),
              onTap: () {
                context.pushNamed(
                  AppRouteNames.friendProfile,
                  pathParameters: {'id': user.id ?? ''},
                );
              },
              trailing: FilledButton(
                onPressed: () {
                  showCustomDialog(
                    context: context,
                    label: intl.addMembers,
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// User card
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                  (user.avatar != null &&
                                          user.avatar!.publicUrl.isNotEmpty)
                                      ? user.avatar!.publicUrl
                                      : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(user.fullName ?? 'User')}&background=random&color=fff&size=128',
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.fullName ?? 'User',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontSize: 14,
                                            letterSpacing: 0,
                                            height: 20 / 14,
                                          ),
                                    ),
                                  ],
                                ),
                              ),

                              Icon(
                                Icons.swap_horiz,
                                color: AppThemes.primary3Color,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        CustomTextInputWidget(
                          size: TextInputSize.large,
                          isReadOnly: false,
                          keyboardType: TextInputType.number,
                          label: intl.amountLabel,
                          controller: _amountController,
                        ),

                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _amountChip("100 K"),
                            _amountChip("200 K"),
                            _amountChip("500 K"),
                          ],
                        ),
                      ],
                    ),
                    actions: [
                      if (isSelected)
                        Center(
                          child: CustomButton(
                            text: intl.removeSelection,
                            customColor: AppThemes.errorColor,
                            size: ButtonSize.popUp,
                            onPressed: () {
                              _togglePayer(PayerModel(user: user, amount: 0));

                              _amountController.clear();

                              Navigator.pop(context);
                            },
                          ),
                        ),

                      if (!isSelected)
                        Center(
                          child: CustomButton(
                            text: intl.confirm,
                            customColor: AppThemes.primary3Color,
                            size: ButtonSize.popUp,
                            onPressed: () {
                              final amount = double.tryParse(
                                _amountController.text,
                              );

                              if (amount == null) return;

                              _togglePayer(
                                PayerModel(user: user, amount: amount),
                              );

                              _amountController.clear();

                              Navigator.pop(context);
                            },
                          ),
                        ),
                    ],
                  );
                },
                style: FilledButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(8),
                  backgroundColor: isSelected
                      ? AppThemes.primary3Color
                      : Colors.transparent,
                  side: BorderSide(
                    color: isSelected ? AppThemes.primary3Color : Colors.grey,
                  ),
                ),
                child: Icon(
                  isSelected ? Icons.check : Icons.add,
                  size: 18,
                  color: isSelected ? Colors.white : Colors.grey,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _amountChip(String text) {
    return OutlinedButton(
      onPressed: () {
        _amountController.text = text.replaceAll(' K', '000');
      },
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(60, 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      child: Text(text),
    );
  }
}
