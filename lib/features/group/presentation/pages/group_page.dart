import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/group/data/models/group_member_model.dart';
import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/features/group/presentation/bloc/group_bloc.dart';
import 'package:Dividex/features/group/presentation/bloc/group_event.dart';
import 'package:Dividex/features/group/presentation/bloc/group_state.dart';
import 'package:Dividex/features/group/presentation/member_carousel.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/utils/num.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/content_card.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_dropdown_widget.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/settle_up_pop_up.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  final List<GroupModel> _groupList = [];

  final _textEditingController = TextEditingController();
  final ValueNotifier<CurrencyEnum> _selectedCurrency = ValueNotifier(
    CurrencyEnum.vnd,
  );
  final List<CurrencyEnum> _units = CurrencyEnum.values;

  List<int> _selectedMemberIndices = [];

  @override
  void initState() {
    super.initState();
    context.read<LoadedGroupsBloc>().add(InitialEvent('', true));
    _selectedCurrency.value = CurrencyEnum.values.firstWhere(
      (c) =>
          c.code ==
          (HiveService.getUser().preferredCurrency ?? CurrencyEnum.vnd.code),
      orElse: () => CurrencyEnum.vnd,
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AppShell(
      currentIndex: 0,
      child: SimpleLayout(
        title: intl.group,
        child: Column(
          children: [
            SizedBox(
              width: 340,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 7, // 70%
                    child: // Search
                    CustomTextInputWidget(
                      size: TextInputSize.large,
                      isReadOnly: false,
                      keyboardType: TextInputType.text,
                      label: intl.searchTab,
                      controller: _textEditingController,
                      suffixIcon: IconButton(
                        onPressed: () {
                          context.read<LoadedGroupsBloc>().add(
                            InitialEvent(_textEditingController.text, true),
                          );
                        },
                        icon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3, // 30%
                    child: ValueListenableBuilder<CurrencyEnum>(
                      valueListenable: _selectedCurrency,
                      builder: (context, value, _) {
                        return CustomDropdownWidget<CurrencyEnum>(
                          label: intl.expenseCurrencyLabel,
                          value: _selectedCurrency.value,
                          options: _units,
                          displayString: (b) => b.code,
                          buildOption: (b, selected) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 4,
                              ),
                              child: Row(
                                children: [
                                  // if (b.avatarUrl != null)
                                  //   Image.network(
                                  //     b.avatarUrl!,
                                  //     width: 50,
                                  //     height: 50,
                                  //     errorBuilder: (context, error, stackTrace) =>
                                  //         const Icon(Icons.group),
                                  //   )
                                  // else
                                  //   const Icon(Icons.group),
                                  Text(
                                    b.code,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: selected
                                              ? AppThemes.primary3Color
                                              : Colors.grey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      b.description,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: selected
                                                ? AppThemes.primary3Color
                                                : Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ),
                                  if (selected)
                                    const Icon(
                                      Icons.check,
                                      color: AppThemes.primary3Color,
                                    ),
                                ],
                              ),
                            );
                          },
                          onChanged: (val) {
                            _selectedCurrency.value = val!;
                            HiveService.saveUser(
                              HiveService.getUser().copyWith(
                                preferredCurrency: val.code,
                              ),
                            );
                            // print('Selected currency: ${val.code}');
                            // print(
                            //   'Saved preferred currency: ${HiveService.getUser().preferredCurrency ?? 'null'}',
                            // );
                          },
                          isRequired: true,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            BlocBuilder<LoadedGroupsBloc, LoadedGroupsState>(
              buildWhen: (p, c) =>
                  p.groups != c.groups || p.isLoading != c.isLoading,
              builder: (context, state) {
                if (state.isLoading) {
                  return Center(
                    child: SpinKitFadingCircle(color: AppThemes.primary3Color),
                  );
                }

                if (state.groups.isEmpty) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<LoadedGroupsBloc>().add(
                            RefreshGroupsEvent('', true),
                          );
                        },
                        child: noGroupWidget(intl, theme),
                      );
                    },
                  );
                }

                _groupList.clear();
                _groupList.addAll(state.groups);

                // chỉ khởi tạo khi chưa có dữ liệu (tránh reset mỗi lần build)
                if (_selectedMemberIndices.length != _groupList.length) {
                  _selectedMemberIndices = List.filled(_groupList.length, 0);
                }

                bool hasMore = state.page < state.totalPage;

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _groupList.length + (hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _groupList.length) {
                      // Load more indicator
                      if (hasMore) {
                        context.read<LoadedGroupsBloc>().add(
                          LoadMoreGroupsEvent(
                            _textEditingController.text,
                            true,
                          ),
                        );
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: SpinKitFadingCircle(
                                color: AppThemes.primary3Color,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    }

                    final group = _groupList[index];
                    final members =
                        group.members
                            ?.where(
                              (m) => m.user?.id != HiveService.getUser().id,
                            )
                            .toList() ??
                        [];

                    if (members.isEmpty) {
                      // group chỉ có 1 người là mình → không có ai để hiển thị
                      return groupWidget(
                        context,
                        group,
                        intl,
                        const [], // gửi list rỗng vào widget
                        index,
                        null // currentMember null
                      );
                    }

                    final currentMember =
                        members[_selectedMemberIndices[index]];

                    if (_selectedMemberIndices[index] >= members.length) {
                      _selectedMemberIndices[index] = 0;
                    }

                    if (index == 0) {
                      return Column(
                        children: [
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(
                                text: intl.group,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      fontSize: 12,
                                      letterSpacing: 0,
                                      height: 16 / 12,
                                      color: Colors.grey,
                                    ),
                                children: state.totalItems > 0
                                    ? [
                                        TextSpan(
                                          text: state.totalItems > 99
                                              ? ' 99+'
                                              : ' ${state.totalItems}',
                                          style: TextStyle(
                                            color: AppThemes.primary3Color,
                                          ),
                                        ),
                                      ]
                                    : [],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          groupWidget(
                            context,
                            group,
                            intl,
                            members,
                            index,
                            currentMember,
                          ),
                        ],
                      );
                    }

                    return groupWidget(
                      context,
                      group,
                      intl,
                      members,
                      index,
                      currentMember,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  ContentCard groupWidget(
    BuildContext context,
    GroupModel group,
    AppLocalizations intl,
    List<GroupMemberModel> members,
    int index,
    GroupMemberModel? currentMember,
  ) {
    return ContentCard(
      onTap: () {
        context.pushNamed(
          AppRouteNames.groupDetail,
          pathParameters: {'groupId': group.id ?? ''},
          extra: {
            'groupName': group.name ?? '',
            'groupAvatarUrl': group.avatarUrl?.publicUrl ?? '',
            'leaderId': group.leader?.id ?? '',
          },
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              gradient: LinearGradient(
                colors: [Color(0xFFD23B6C), Color(0xFFE25D64)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey,
                  backgroundImage:
                      (group.avatarUrl != null &&
                          group.avatarUrl!.publicUrl.isNotEmpty)
                      ? NetworkImage(group.avatarUrl!.publicUrl)
                      : NetworkImage(
                          'https://ui-avatars.com/api/?name=${Uri.encodeComponent(group.name ?? 'Group')}&background=random&color=fff&size=128',
                        ),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.name ?? '',
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(color: Colors.white),
                    ),
                    Text(
                      intl.membersText(members.length + 1),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppThemes.borderColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (currentMember != null) ...[
            /// Member carousel
            Container(
              alignment: Alignment.center,
              child: MemberCarousel(
                members: members,
                onChanged: (idx) {
                  setState(() {
                    if (members[index].id == HiveService.getUser().id) {
                      _selectedMemberIndices[index] =
                          ((idx + 1) % members.length);
                    } else {
                      _selectedMemberIndices[index] = idx;
                    }
                  });
                },
              ),
            ),

            /// Debt info
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  (currentMember.amount != null && currentMember.amount! >= 0)
                      ? '${currentMember.user?.fullName} ${intl.ownYou}'
                      : '${intl.youOwn} ${currentMember.user?.fullName}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),

                Text(
                  '${formatNumber(currentMember.amount?.abs() ?? 0)} ${_selectedCurrency.value.code}',
                  style: TextStyle(
                    color:
                        (currentMember.amount != null &&
                            currentMember.amount! >= 0)
                        ? AppThemes.successColor
                        : AppThemes.minusMoney,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // Button action
            if (currentMember.amount != 0) ...[
              const SizedBox(height: 5),

              CustomButton(
                size: ButtonSize.medium,
                text:
                    (currentMember.amount != null && currentMember.amount! > 0)
                    ? intl.remind
                    : intl.pay,
                onPressed: () {
                  if (currentMember.amount != null &&
                      currentMember.amount! > 0) {
                    // Xử lý nhắc nhở
                  } else {
                    showSettleUpDialog(
                      context: context,
                      receiver: currentMember.user!,
                      amount: currentMember.amount!.abs(),
                      currency: _selectedCurrency.value,
                      groupId: group.id!,
                    );
                  }
                },
                customColor:
                    (currentMember.amount != null && currentMember.amount! > 0)
                    ? AppThemes.successColor
                    : AppThemes.minusMoney,
              ),
            ],
          ],
        ],
      ),
    );
  }

  LayoutBuilder noGroupWidget(AppLocalizations intl, ThemeData theme) {
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
}
