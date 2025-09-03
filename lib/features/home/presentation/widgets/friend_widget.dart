import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_event.dart';
import 'package:Dividex/features/home/presentation/widgets/format.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/presentation/bloc/user_bloc.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart';
import 'package:Dividex/features/user/presentation/bloc/user_state.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:marquee/marquee.dart';

class FriendWidget extends StatefulWidget {
  const FriendWidget({super.key});

  @override
  State<FriendWidget> createState() => _FriendWidgetState();
}

class _FriendWidgetState extends State<FriendWidget> {
  final TextEditingController _searchController = TextEditingController();

  final List<UserModel> _friendList = [];

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CustomTextInput(
            label: intl.searchTab,
            controller: _searchController,
            suffixIcon: IconButton(
              onPressed: () {
                context.read<LoadedUsersBloc>().add(
                  RefreshUsersEvent(
                    HiveService.getUser().id,
                    LoadUsersAction.getUsersBySearch,
                    searchQuery: _searchController.text.isEmpty
                        ? null
                        : _searchController.text,
                  ),
                );
              },
              icon: Icon(Icons.search),
            ),
          ),
          Expanded(
            child: BlocBuilder<LoadedUsersBloc, LoadedUsersState>(
              buildWhen: (p, c) =>
                  p.users != c.users || p.isLoading != c.isLoading,
              builder: (context, state) {
                if (state.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                final theme = Theme.of(context);

                if (state.users.isEmpty) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.person_add,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              intl.noFriends,
                              style: theme.textTheme.titleSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              intl.addFirstFriend,
                              style: theme.textTheme.bodySmall!.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }

                _friendList.clear();
                _friendList.addAll(state.users);

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<LoadedUsersBloc>().add(
                      RefreshUsersEvent(
                        HiveService.getUser().id,
                        LoadUsersAction.getFriends,
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          intl.friend,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: AppThemes.primary3Color),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(0.0),
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: _friendList.length,
                          itemBuilder: (context, index) {
                            final friend = _friendList[index];

                            return BlocProvider(
                              create: (context) => FriendBloc(),
                              child: Slidable(
                                key: ValueKey(friend.id),
                                endActionPane: friendCardAction(friend, intl),
                                child: Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  margin: const EdgeInsets.only(bottom: 6),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(6),
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        friend.avatar ?? '',
                                      ),
                                      radius: 25,
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                    ),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          friend.fullName ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                              
                                        if (friend.hasDebt ?? false)
                                          UserDebtInfo(
                                            friend: friend,
                                            intl: intl,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  ActionPane friendCardAction(UserModel friend, AppLocalizations intl) {
    print('Friend hasDebt: ${friend.hasDebt}');
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        if (friend.hasDebt ?? false)
          SlidableAction(
            onPressed: (context) {
              // Nhắc nhở hoặc trả
            },
            backgroundColor: (friend.hasDebt ?? false)
                ? Colors.red
                : Colors.green,
            foregroundColor: Colors.white,
            icon: (friend.hasDebt ?? false)
                ? Icons.arrow_forward_sharp
                : Icons.arrow_back_sharp,
            label: (friend.hasDebt ?? false) ? intl.pay : intl.remind,
          ),
        if (friend.hasDebt == null)
          SlidableAction(
            onPressed: (context) {
              print('Sending friend request to ${friend.fullName}');
              context.read<FriendBloc>().add(
                SendFriendRequestEvent(
                  friend.id!,
                  message: 'Test message',
                ),
              );
            },
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.person_add,
            label: intl.addFriend,
          ),
      ],
    );
  }
}

class UserDebtInfo extends StatelessWidget {
  const UserDebtInfo({super.key, required this.friend, required this.intl});

  final UserModel friend;
  final AppLocalizations intl;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          (friend.hasDebt ?? false)
              ? Icons.arrow_forward_sharp
              : Icons.arrow_back_sharp,
          color: (friend.hasDebt ?? false) ? Colors.red : Colors.green,
        ),
        const SizedBox(width: 4),
        Text(
          (friend.hasDebt ?? false) ? intl.youOwn : intl.ownYou,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: (friend.hasDebt ?? false) ? Colors.red : Colors.green,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          "${formatCurrency(friend.amount!)} ₫",
          style: TextStyle(
            color: (friend.hasDebt ?? false) ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
