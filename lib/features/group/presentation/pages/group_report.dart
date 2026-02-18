import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/event_expense/data/models/event_model.dart';
import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/features/group/presentation/bloc/group_bloc.dart';
import 'package:Dividex/features/group/presentation/bloc/group_event.dart'
    as group_event;
import 'package:Dividex/features/group/presentation/bloc/group_state.dart';
import 'package:Dividex/features/group/presentation/widgets/chart_widget.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/presentation/bloc/user_bloc.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart'
    as load_user_event;
import 'package:Dividex/features/user/presentation/bloc/user_state.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/utils/num.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/content_card.dart';
import 'package:Dividex/shared/widgets/info_card.dart';
import 'package:Dividex/shared/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class GroupReportPage extends StatefulWidget {
  final String groupId;
  const GroupReportPage({super.key, required this.groupId});

  @override
  State<GroupReportPage> createState() => _GroupReportPageState();
}

class _GroupReportPageState extends State<GroupReportPage> {
  late String groupName;
  late String groupAvatarUrl;

  @override
  void initState() {
    super.initState();
    context.read<GroupBloc>().add(
      group_event.GetGroupReportEvent(widget.groupId),
    );
    context.read<LoadedUsersBloc>().add(
      load_user_event.InitialEvent(
        widget.groupId,
        load_user_event.LoadType.groupMembers,
        searchQuery: '',
      ),
    );
    context.read<LoadedGroupsEventsBloc>().add(
      group_event.LoadGroupEventsEventInitial(
        page: 1,
        pageSize: 10,
        groupId: widget.groupId,
        searchQuery: '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AppShell(
      currentIndex: 0,
      child: Layout(
        onRefresh: () {
          context.read<GroupBloc>().add(
            group_event.GetGroupReportEvent(widget.groupId),
          );
          context.read<LoadedUsersBloc>().add(
            load_user_event.InitialEvent(
              widget.groupId,
              load_user_event.LoadType.groupMembers,
              searchQuery: '',
            ),
          );
          context.read<LoadedGroupsEventsBloc>().add(
            group_event.LoadGroupEventsEventInitial(
              page: 1,
              pageSize: 10,
              groupId: widget.groupId,
              searchQuery: '',
            ),
          );
          return Future.value();
        },
        title: intl.report,
        child: Column(
          children: [
            BlocBuilder<GroupBloc, GroupState>(
              builder: (context, state) {
                if (state is! GroupReportState) {
                  return const Center(
                    child: ColoredBox(
                      color: Colors.transparent,
                      child: SpinKitFadingCircle(
                        color: AppThemes.primary3Color,
                      ),
                    ),
                  );
                }

                groupName = state.groupDetail?.name ?? '';
                groupAvatarUrl = state.groupDetail?.avatarUrl?.publicUrl ?? '';

                return Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        intl.overview,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 12,
                          letterSpacing: 0,
                          height: 16 / 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    ContentCard(
                      child: Column(
                        children: [
                          buildGroupInfoRow(
                            intl.totalEvents,
                            state.groupDetail?.eventAttended ?? '',
                          ),
                          const Divider(
                            height: 1,
                            color: AppThemes.borderColor,
                          ),
                          buildGroupInfoRow(
                            intl.totalExpenses,
                            state.groupDetail?.sharedExpenses ?? '',
                          ),
                          const Divider(
                            height: 1,
                            color: AppThemes.borderColor,
                          ),
                          buildGroupInfoRow(
                            intl.totalSpending,
                            formatNumber(state.groupDetail?.totalAmount ?? 0),
                          ),
                          const Divider(
                            height: 1,
                            color: AppThemes.borderColor,
                          ),
                          buildGroupInfoRow(
                            intl.userSpending,
                            formatNumber(state.groupDetail?.userSpent ?? 0),
                          ),
                          const Divider(
                            height: 1,
                            color: AppThemes.borderColor,
                          ),
                          buildGroupInfoRow(
                            intl.contributionRate,
                            '${(getRatio(((state.groupDetail?.userSpent ?? 0) / (state.groupDetail?.totalAmount ?? 1) * 100))).toStringAsFixed(2)}%',
                          ),
                          const Divider(
                            height: 1,
                            color: AppThemes.borderColor,
                          ),
                          buildGroupInfoRow(
                            intl.leader,
                            state.groupReport?.leader?.fullName.toString() ??
                                '',
                          ),
                          const Divider(
                            height: 1,
                            color: AppThemes.borderColor,
                          ),
                          buildGroupNetBalanceRow(
                            intl.netBalance,
                            state.groupDetail?.restructuredDebt ?? [],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        intl.contributon,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 12,
                          letterSpacing: 0,
                          height: 16 / 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    ContributionPieChart(chartData: state.chartData ?? []),
                  ],
                );
              },
            ),

            const SizedBox(height: 10),
            // Events
            BlocBuilder<LoadedGroupsEventsBloc, LoadedGroupsEventsState>(
              buildWhen: (p, c) =>
                  p.events != c.events || p.isLoading != c.isLoading,
              builder: (context, eventsState) {
                if (eventsState.isLoading) {
                  return const Center(
                    child: ColoredBox(
                      color: Colors.transparent,
                      child: SpinKitFadingCircle(
                        color: AppThemes.primary3Color,
                      ),
                    ),
                  );
                } else if (eventsState.events.isEmpty) {
                  return noUserWidget(intl, theme, isEvent: true);
                }

                final hasMore = eventsState.page < eventsState.totalPage;

                return listEventResults(
                  intl,
                  hasMore,
                  eventsState.totalItems,
                  eventsState.page,
                  eventsState.events,
                );
              },
            ),

            const SizedBox(height: 10),
            // Members
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
                  usersWithoutMyself,
                  state.page,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGroupInfoRow(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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

  Widget buildGroupNetBalanceRow(
    String title,
    List<RestructuredDebtModel> value,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: value.map((debt) {
              // create a non-null numeric amount and then format it
              final double amountNum = debt.value != null
                  ? double.parse(debt.value!.toStringAsFixed(2))
                  : 0.0;
              final String amount = formatNumber(amountNum);

              bool isOwedToMe = debt.creditor?.id == HiveService.getUser().id;
              UserModel? notMe = isOwedToMe ? debt.debtor : debt.creditor;

              return Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          (notMe?.avatar != null &&
                              notMe!.avatar!.publicUrl.isNotEmpty)
                          ? NetworkImage(notMe.avatar!.publicUrl)
                          : NetworkImage(
                              'https://ui-avatars.com/api/?name=${Uri.encodeComponent(notMe?.fullName ?? 'User')}&background=random&color=fff&size=128',
                            ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      notMe?.fullName?.split(' ').last ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppThemes.primary3Color,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${isOwedToMe ? '+' : '-'} $amount ${HiveService.getUser().preferredCurrency ?? 'VND'}',
                      style: TextStyle(
                        color: isOwedToMe
                            ? AppThemes.successColor
                            : AppThemes.minusMoney,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  LayoutBuilder noUserWidget(
    AppLocalizations intl,
    ThemeData theme, {
    bool isEvent = false,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                isEvent ? intl.event : intl.members,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 12,
                  letterSpacing: 0,
                  height: 16 / 12,
                  color: Colors.grey,
                ),
              ),
            ),

            const SizedBox(height: 8),
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  isEvent
                      ? Icon(
                          Icons.event_busy,
                          size: 64,
                          color: Colors.grey[400],
                        )
                      : Icon(
                          Icons.no_accounts,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                  const SizedBox(height: 16),
                  Text(intl.noSearchResults, style: theme.textTheme.titleSmall),
                ],
              ),
            ),
          ],
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
              text: intl.members,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 12,
                letterSpacing: 0,
                height: 16 / 12,
                color: Colors.grey,
              ),
              children: totalUsers > 0
                  ? [
                      TextSpan(
                        text: totalUsers > 99 ? ' 99+' : ' $totalUsers',
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
                load_user_event.LoadMoreUsersEvent(
                  page + 1,
                  widget.groupId,
                  load_user_event.LoadType.groupMembers,
                  searchQuery: '',
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

            return InfoCard(
              title: user.fullName ?? '',
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
            );
          },
        ),
      ],
    );
  }

  Column listEventResults(
    AppLocalizations intl,
    bool hasMore,
    int totalUsers,
    int page,
    List<EventModel>? events,
  ) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: intl.event,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 12,
                letterSpacing: 0,
                height: 16 / 12,
                color: Colors.grey,
              ),
              children: totalUsers > 0
                  ? [
                      TextSpan(
                        text: totalUsers > 99 ? ' 99+' : ' $totalUsers',
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
          itemCount: events?.length != null
              ? (events!.length + (hasMore ? 1 : 0))
              : 0,
          itemBuilder: (context, index) {
            if (index == events!.length) {
              context.read<LoadedGroupsEventsBloc>().add(
                group_event.LoadMoreEventsEvent(
                  page: page + 1,
                  pageSize: 10,
                  groupId: widget.groupId,
                  searchQuery: '',
                ),
              );
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: SpinKitFadingCircle(color: AppThemes.primary3Color),
                ),
              );
            }

            final event = events[index];

            return ContentCard(
              onTap: () {
                context.goNamed(
                  AppRouteNames.eventReport,
                  pathParameters: {
                    'eventId': event.id ?? '',
                    'groupId': widget.groupId,
                  },
                  extra: {'eventName': event.name ?? ''},
                );
              },
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 5,
                      children: [
                        Text(
                          event.name ?? '',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${event.eventStart != null ? DateFormat('dd/MM/yyyy').format(event.eventStart!) : ''} - ${event.eventEnd != null ? DateFormat('dd/MM/yyyy').format(event.eventEnd!) : ''}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppThemes.primary3Color,
                              ),
                        ),
                      ],
                    ),
                  ),
                  if (event.description != null) ...[
                    const SizedBox(height: 4),
                    const Divider(height: 1, color: AppThemes.borderColor),
                    const SizedBox(height: 4),
                    Text(
                      event.description!,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

double getRatio(double? d) {
  if (d == null || d.isNaN || d.isInfinite) {
    return 0.0; // giá trị mặc định an toàn
  }
  return d;
}
