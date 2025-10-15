import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/event_expense/data/models/event_model.dart';
import 'package:Dividex/features/group/presentation/bloc/group_bloc.dart';
import 'package:Dividex/features/group/presentation/bloc/group_event.dart'
    as group_event;
import 'package:Dividex/features/group/presentation/bloc/group_state.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/presentation/bloc/user_bloc.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart';
import 'package:Dividex/features/user/presentation/bloc/user_state.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/content_card.dart';
import 'package:Dividex/shared/widgets/info_card.dart';
import 'package:Dividex/shared/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class GroupDetailPage extends StatefulWidget {
  final String groupId;

  const GroupDetailPage({super.key, required this.groupId});

  @override
  State<GroupDetailPage> createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<GroupBloc>().add(
      group_event.GetGroupDetailEvent(widget.groupId),
    );
    context.read<LoadedUsersBloc>().add(
      InitialEvent(widget.groupId, LoadType.groupMembers, searchQuery: ''),
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

    return BlocBuilder<GroupBloc, GroupState>(
      builder: (context, state) {
        if (state is! GroupDetailState) {
          return const Scaffold(
            body: Center(
              child: SpinKitFadingCircle(color: AppThemes.primary3Color),
            ),
          );
        }

        return AppShell(
          currentIndex: 0,
          child: Layout(
            title: state.groupDetail?.name ?? '',
            showAvatar: true,
            action: IconButton(
              iconSize: 30,
              onPressed: () {
                context.pushNamed(
                  AppRouteNames.groupSetting,
                  pathParameters: {'groupId': widget.groupId},
                  extra: {
                    'groupName': state.groupDetail?.name ?? '',
                    'leaderId': state.groupDetail?.leader?.id ?? '',
                    'groupAvatarUrl': state.groupDetail?.avatarUrl ?? '',
                  },
                );
              },
              icon: SizedBox(
                width: 30,
                height: 30,
                child: Icon(
                  Icons.settings_outlined,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
            avatarUrl:
                state.groupDetail?.avatarUrl != null &&
                    state.groupDetail!.avatarUrl!.publicUrl.isNotEmpty
                ? state.groupDetail!.avatarUrl?.publicUrl
                : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(state.groupDetail?.name ?? '')}&background=random&color=fff&size=128',
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    context.pushNamed(
                      AppRouteNames.groupReport,
                      pathParameters: {'groupId': widget.groupId},
                      extra: {
                        'groupName': state.groupDetail?.name ?? '',
                        'groupAvatarUrl':
                            state.groupDetail?.avatarUrl?.publicUrl ?? '',
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          intl.report,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontSize: 12,
                                letterSpacing: 0,
                                height: 16 / 12,
                                color: Colors.grey,
                              ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

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
                      const Divider(height: 1, color: AppThemes.borderColor),
                      buildGroupInfoRow(
                        intl.totalExpenses,

                        state.groupDetail?.sharedExpenses ?? '',
                      ),
                      const Divider(height: 1, color: AppThemes.borderColor),
                      buildGroupInfoRow(
                        intl.totalSpending,
                        state.groupDetail?.totalAmount.toString() ?? '',
                      ),
                      const Divider(height: 1, color: AppThemes.borderColor),
                      buildGroupInfoRow(
                        intl.userSpending,
                        state.groupDetail?.userSpent.toString() ?? '',
                      ),
                      const Divider(height: 1, color: AppThemes.borderColor),
                      buildGroupInfoRow(
                        intl.contributionRate,
                        '${((state.groupDetail?.userSpent ?? 0) / (state.groupDetail?.totalAmount ?? 1) * 100).toStringAsFixed(2)}%',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                const SizedBox(height: 10),
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
                      state,
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
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
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
                LoadMoreUsersEvent(
                  widget.groupId,
                  LoadType.groupMembers,
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
                // Navigate to friend's profile
                print('Navigate to ${user.fullName} profile');
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
    GroupDetailState state,
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
                  extra: {
                    'eventName': event.name ?? '',
                    'groupName': state.groupDetail?.name ?? '',
                    'groupAvatarUrl': state.groupDetail?.avatarUrl ?? '',
                  },
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
