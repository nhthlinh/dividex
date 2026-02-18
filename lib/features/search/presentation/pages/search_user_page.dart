import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/friend/data/models/friend_model.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_event.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_state.dart';
import 'package:Dividex/features/friend/presentation/friend_card.dart';
import 'package:Dividex/features/search/presentation/bloc/search_users_bloc.dart'
    as search_bloc;
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SearchUserPage extends StatefulWidget {
  const SearchUserPage({super.key});

  @override
  State<SearchUserPage> createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<search_bloc.SearchUsersBloc>().add(
      InitialEvent(HiveService.getUser().id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return AppShell(
      currentIndex: 1,
      child: SimpleLayout(
        onRefresh: () {
          context.read<search_bloc.SearchUsersBloc>().add(
            InitialEvent(HiveService.getUser().id),
          );
          return Future.value();
        },
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
                  context.read<search_bloc.SearchUsersBloc>().add(
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

            // results
            BlocBuilder<search_bloc.SearchUsersBloc, LoadedFriendsState>(
              buildWhen: (p, c) =>
                  p.requests != c.requests || p.isLoading != c.isLoading,
              builder: (context, searchState) {
                if (searchState.isLoading) {
                  return const Center(
                    child: ColoredBox(
                      color: Colors.transparent,
                      child: SpinKitFadingCircle(
                        color: AppThemes.primary3Color,
                      ),
                    ),
                  );
                } else if (searchState.requests.isEmpty) {
                  return notFoundWidget(intl, context);
                }

                final hasMore = searchState.page < searchState.totalPage;

                return friendCardList(
                  intl.result,
                  hasMore,
                  context,
                  searchState.requests,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Center notFoundWidget(AppLocalizations intl, BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Icon(Icons.person_search, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            intl.noSearchResults,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Text(
            intl.tryDifferentKeyword,
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Column friendCardList(
    String label,
    bool hasMore,
    BuildContext context,
    List<FriendModel>? friends,
  ) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 12,
              letterSpacing: 0,
              height: 16 / 12,
              color: Colors.grey,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: friends?.length != null
              ? (friends!.length + (hasMore ? 1 : 0))
              : 0,
          itemBuilder: (context, index) {
            if (index == friends!.length) {
              context.read<search_bloc.SearchUsersBloc>().add(
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

            final friend = friends[index];

            return BlocProvider(
              create: (context) => FriendBloc(),
              child: FriendCard(
                isSearchPage: true,
                friend: friend,
                type: friend.status == FriendStatus.accepted
                    ? FriendCardType.acepted
                    : friend.status == FriendStatus.pending
                    ? FriendCardType.pending
                    : friend.status == FriendStatus.response
                    ? FriendCardType.response
                    : FriendCardType.none,
              ),
            );
          },
        ),
      ],
    );
  }
}
