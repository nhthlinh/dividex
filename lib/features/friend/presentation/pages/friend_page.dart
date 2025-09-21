import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/friend/data/models/friend_model.dart';
import 'package:Dividex/features/friend/domain/usecase.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_event.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_request_bloc_and_event.dart'
    as request_bloc;
import 'package:Dividex/features/friend/presentation/bloc/friend_state.dart';
import 'package:Dividex/features/friend/presentation/friend_card.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<LoadedFriendsBloc>().add(
      InitialEvent(HiveService.getUser().id),
    );
    context.read<request_bloc.FriendRequestBloc>().add(
      request_bloc.InitialEvent(
        type: FriendRequestType.received,
        HiveService.getUser().id,
      ),
    );
    context.read<request_bloc.FriendRequestBloc>().add(
      request_bloc.InitialEvent(
        type: FriendRequestType.sent,
        HiveService.getUser().id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return AppShell(
      currentIndex: 0,
      child: SimpleLayout(
        title: intl.friend,
        child: Column(
          children: [
            // Search
            CustomTextInputWidget(
              size: TextInputSize.large,
              isReadOnly: false,
              keyboardType: TextInputType.text,
              label: intl.searchTab,
              controller: _searchController,
              suffixIcon: IconButton(
                onPressed: () {
                  context.read<LoadedFriendsBloc>().add(
                    InitialEvent(
                      HiveService.getUser().id,
                      searchQuery: _searchController.text.isEmpty
                          ? null
                          : _searchController.text,
                    ),
                  );
                },
                icon: Icon(Icons.search),
              ),
            ),

            // receivedRequests
            friendRequestList(intl.received, FriendRequestType.received),

            // sentRequests
            friendRequestList(intl.sent, FriendRequestType.sent),

            // Friend
            BlocBuilder<LoadedFriendsBloc, LoadedFriendsState>(
              buildWhen: (p, c) =>
                  p.requests != c.requests || p.isLoading != c.isLoading,
              builder: (context, state) {
                if (state.isLoading) {
                  return Center(
                    child: ColoredBox(
                      color: Colors.transparent,
                      child: SpinKitFadingCircle(
                        color: AppThemes.primary3Color,
                      ),
                    ),
                  );
                }

                final theme = Theme.of(context);

                if (state.requests.isEmpty) {
                  return noFriendWidget(intl, theme);
                }

                return friendCardList(
                  intl.friend,
                  context,
                  state.page < state.totalPage,
                  state.requests,
                  state.totalItems,
                  FriendCardType.acepted,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  LayoutBuilder noFriendWidget(AppLocalizations intl, ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  intl.friend,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 12,
                    letterSpacing: 0,
                    height: 16 / 12,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Icon(Icons.person_add, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(intl.noFriends, style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              Text(
                intl.addFirstFriend,
                style: theme.textTheme.bodySmall!.copyWith(color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget friendRequestList(String label, FriendRequestType type) {
    return BlocBuilder<
      request_bloc.FriendRequestBloc,
      LoadedFriendRequestsState
    >(
      builder: (context, state) {
        if (state.isLoading) {
          return Center(
            child: ColoredBox(
              color: Colors.transparent,
              child: SpinKitFadingCircle(color: AppThemes.primary3Color),
            ),
          );
        }

        final List<FriendModel> requests = type == FriendRequestType.received
            ? state.received
            : state.sent;

        final totalRequests = type == FriendRequestType.received
            ? state.totalPage
            : state.totalSent;

        if (requests.isEmpty) {
          return const SizedBox.shrink();
        }

        final hasMore = state.page < state.totalPage;

        return friendCardList(
          label,
          context,
          hasMore,
          requests,
          totalRequests,
          type == FriendRequestType.received
              ? FriendCardType.response
              : FriendCardType.pending,
        );
      },
    );
  }

  Column friendCardList(
    String label,
    BuildContext context,
    bool hasMore,
    List<FriendModel>? friends,
    int totalRequests,
    FriendCardType type,
  ) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 12,
                letterSpacing: 0,
                height: 16 / 12,
                color: Colors.grey,
              ),
              children: totalRequests > 0
                  ? [
                      TextSpan(
                        text: totalRequests > 99 ? ' 99+' : ' $totalRequests',
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
          physics: const AlwaysScrollableScrollPhysics(),
            itemCount: friends?.length != null
              ? (friends!.length + (hasMore ? 1 : 0))
              : 0,
          itemBuilder: (context, index) {
            if (index == friends!.length) {
              context.read<LoadedFriendsBloc>().add(
                LoadMoreFriendsEvent(
                  HiveService.getUser().id,
                  searchQuery: _searchController.text.isEmpty
                      ? null
                      : _searchController.text,
                ),
              );
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: SpinKitFadingCircle(color: const Color(0xFF08AE02)),
                ),
              );
            }

            return BlocProvider(
              create: (context) => FriendBloc(),
              child: FriendCard(friend: friends[index], type: type),
            );
          },
        ),
      ],
    );
  }
}
