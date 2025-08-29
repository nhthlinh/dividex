import 'package:Dividex/config/l10n/app_localizations.dart';
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
      child: BlocBuilder<LoadedUsersBloc, LoadedUsersState>(
        buildWhen: (p, c) => p.users != c.users || p.isLoading != c.isLoading,
        builder: (context, state) {
          if (state.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state.users.isEmpty) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<LoadedUsersBloc>().add(
                      RefreshUsersEvent(
                        HiveService.getUser().id,
                        LoadUsersAction.getFriends,
                      ),
                    );
                  },
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: Center(child: Text('Empty')),
                    ),
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
                CustomTextInput(
                  label: intl.searchTab,
                  controller: _searchController,
                  suffixIcon: IconButton(
                    onPressed: () {
                      context.read<LoadedUsersBloc>().add(
                        RefreshUsersEvent(
                          HiveService.getUser().id,
                          LoadUsersAction.getFriends,
                          searchQuery: _searchController.text.isEmpty
                              ? null
                              : _searchController.text,
                        ),
                      );
                    },
                    icon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _friendList.length,
                    itemBuilder: (context, index) {
                      final friend = _friendList[index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),

                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(friend.avatar ?? ''),
                            radius: 25,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20, // bắt buộc set height
                                  child: Marquee(
                                    text: friend.fullName ?? '',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleSmall,
                                    scrollAxis: Axis.horizontal,
                                    blankSpace: 30.0,
                                    velocity: 30.0, // tốc độ
                                    pauseAfterRound: Duration(seconds: 1),
                                    startPadding: 10.0,
                                    accelerationDuration: Duration(seconds: 1),
                                    accelerationCurve: Curves.linear,
                                    decelerationDuration: Duration(
                                      milliseconds: 500,
                                    ),
                                    decelerationCurve: Curves.easeOut,
                                  ),
                                ),
                                const SizedBox(height: 4),

                                SingleChildScrollView(
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Icon(
                                        (friend.hasDebt ?? false)
                                            ? Icons.arrow_forward_sharp
                                            : Icons.arrow_back_sharp,
                                        color: (friend.hasDebt ?? false)
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        (friend.hasDebt ?? false)
                                            ? intl.youOwn
                                            : intl.ownYou,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: (friend.hasDebt ?? false)
                                                  ? Colors.red
                                                  : Colors.green,
                                            ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "${formatCurrency(friend.amount!)} ₫",
                                        style: TextStyle(
                                          color: (friend.hasDebt ?? false)
                                              ? Colors.red
                                              : Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: CustomButton(
                            buttonText: (friend.hasDebt ?? false)
                                ? intl.pay
                                : intl.remind,
                            onPressed: () {},
                            color: (friend.hasDebt ?? false)
                                ? Colors.green[700]
                                : Colors.red[700],
                            isBig: false,
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
    );
  }
}
