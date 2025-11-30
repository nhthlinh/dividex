import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_event.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_state.dart';
import 'package:Dividex/features/image/data/models/image_model.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/presentation/bloc/user_bloc.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart'
    as user_event;
import 'package:Dividex/features/user/presentation/bloc/user_state.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/utils/num.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/content_card.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_form_wrapper.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/layout.dart';
import 'package:Dividex/shared/widgets/settle_up_pop_up.dart';
import 'package:Dividex/shared/widgets/show_dialog_widget.dart';
import 'package:Dividex/shared/widgets/user_grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FriendProfilePage extends StatefulWidget {
  final String friendId;

  const FriendProfilePage({super.key, required this.friendId});

  @override
  State<FriendProfilePage> createState() => _FriendProfilePageState();
}

class _FriendProfilePageState extends State<FriendProfilePage> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<FriendBloc>().add(GetFriendOverviewEvent(widget.friendId));
    context.read<LoadedUsersBloc>().add(
      user_event.InitialEvent(
        widget.friendId,
        user_event.LoadType.mutualFriends,
      ),
    );
    context.read<LoadFriendDeptBloc>().add(InitialEvent(widget.friendId));
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocBuilder<FriendBloc, FriendState>(
      builder: (context, state) {
        if (state is! FriendOverviewState) {
          return const Scaffold(
            body: Center(
              child: SpinKitFadingCircle(color: AppThemes.primary3Color),
            ),
          );
        }

        return AppShell(
          currentIndex: 0,
          child: Layout(
            title: intl.friend,
            showAvatar: true,
            avatarUrl: (() {
              final overview = state.overview;
              final avatar = overview?.friend.avatar;
              final publicUrl = avatar?.publicUrl;
              if (publicUrl != null && publicUrl.isNotEmpty) {
                return publicUrl;
              }
              return 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(overview?.friend.fullName ?? '')}&background=random&color=fff&size=128';
            })(),
            action: ((state.overview?.status != 'ACCEPTED' &&
                    state.overview?.message != null) || (state.overview?.status == 'NONE' ||
                    state.overview?.status == 'NOTYET')) ? null : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomButton(
                  text: intl.delete,
                  onPressed: () {
                    context.read<FriendBloc>().add(
                      DeclineFriendRequestEvent(
                        state.overview!.friendshipUid ?? '',
                      ),
                    );
                  },
                  size: ButtonSize.medium,
                  type: ButtonType.secondary,
                  customColor: AppThemes.primary3Color,
                ),
              ],
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    state.overview?.friend.fullName ?? '',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppThemes.primary3Color,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                if (state.overview?.status != 'ACCEPTED' &&
                    state.overview?.message != null)
                  ContentCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            intl.addFriendMessage,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontSize: 12,
                              letterSpacing: 0,
                              height: 16 / 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.overview?.message ?? '',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (state.overview?.status == 'RECEIVED')
                              CustomButton(
                                text: intl.accept,
                                onPressed: () {
                                  context.read<FriendBloc>().add(
                                    AcceptFriendRequestEvent(
                                      state.overview!.friendshipUid!,
                                    ),
                                  );
                                },
                                size: ButtonSize.medium,
                                customColor: AppThemes.primary3Color,
                              ),
                            if (state.overview?.status == 'SENT')
                              CustomButton(
                                text: intl.cancel,
                                onPressed: () {
                                  context.read<FriendBloc>().add(
                                    DeclineFriendRequestEvent(
                                      state.overview!.friendshipUid!,
                                    ),
                                  );
                                },
                                size: ButtonSize.medium,
                                type: ButtonType.secondary,
                                customColor: AppThemes.errorColor,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                if (state.overview?.status == 'NONE' ||
                    state.overview?.status == 'NOTYET')
                  CustomButton(
                    text: intl.addFriend,
                    onPressed: () {
                      showFriendRequestDialog(
                        context,
                        intl,
                        state.overview!.friend,
                      );
                    },
                    size: ButtonSize.medium,
                    customColor: AppThemes.primary3Color,
                  ),

                const SizedBox(height: 16),

                // Friend
                BlocBuilder<LoadedUsersBloc, LoadedUsersState>(
                  buildWhen: (p, c) =>
                      p.users != c.users || p.isLoading != c.isLoading,
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

                    if (state.users.isEmpty) {
                      return SizedBox.shrink();
                    }

                    final friends = state.users;
                    final hasMore = state.page < state.totalPage;

                    return Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            intl.mutualFriends,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  fontSize: 12,
                                  letterSpacing: 0,
                                  height: 16 / 12,
                                  color: Colors.grey,
                                ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 120,
                          margin: const EdgeInsets.only(top: 8),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: (friends.length + (hasMore ? 1 : 0)),
                            itemBuilder: (context, index) {
                              if (index == friends.length) {
                                context.read<LoadedUsersBloc>().add(
                                  user_event.LoadMoreUsersEvent(
                                    state.page + 1,
                                    widget.friendId,
                                    user_event.LoadType.mutualFriends,
                                  ),
                                );
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Center(
                                    child: SpinKitFadingCircle(
                                      color: const Color(0xFF08AE02),
                                    ),
                                  ),
                                );
                              }

                              return SquareIconUser(
                                key: ValueKey(friends[index].id),
                                user: friends[index],
                                size: 100,
                                isSelectable: false,
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 16),

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
                        intl.mutualGroups,
                        state.overview?.mutualGroups.toString() ?? '',
                      ),
                      const Divider(height: 1, color: AppThemes.borderColor),
                      buildGroupInfoRow(
                        intl.sharedEvents,
                        state.overview?.sharedEvents.toString() ?? '',
                      ),
                      const Divider(height: 1, color: AppThemes.borderColor),
                      buildGroupInfoRow(
                        intl.totalExpenses,
                        state.overview?.sharedExpenses.toString() ?? '',
                      ),
                      const Divider(height: 1, color: AppThemes.borderColor),
                      buildGroupInfoRow(
                        intl.totalDebt,
                        formatNumber(state.overview?.totalDebt ?? 0),
                      ),
                    ],
                  ),
                ),

                BlocBuilder<LoadFriendDeptBloc, LoadFriendDeptState>(
                  buildWhen: (p, c) =>
                      p.depts != c.depts || p.isLoading != c.isLoading,
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

                    if (state.depts.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    final hasMore = state.page < state.totalPage;

                    return Column(
                      children: [
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            text: TextSpan(
                              text: intl.mutualGroups,
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
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: (state.depts.length + (hasMore ? 1 : 0)),
                          itemBuilder: (context, index) {
                            if (index == state.depts.length) {
                              context.read<LoadFriendDeptBloc>().add(
                                LoadMoreFriendsEvent(HiveService.getUser().id),
                              );
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Center(
                                  child: SpinKitFadingCircle(
                                    color: const Color(0xFF08AE02),
                                  ),
                                ),
                              );
                            }

                            final group = state.depts[index].group;
                            final creditor = state.depts[index].creditor;
                            final deptor = state.depts[index].debtor;

                            return ContentCard(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.grey,
                                        backgroundImage:
                                            (group.avatarUrl != null &&
                                                group
                                                    .avatarUrl!
                                                    .publicUrl
                                                    .isNotEmpty)
                                            ? NetworkImage(
                                                group.avatarUrl!.publicUrl,
                                              )
                                            : NetworkImage(
                                                'https://ui-avatars.com/api/?name=${Uri.encodeComponent(group.name ?? 'Group')}&background=random&color=fff&size=128',
                                              ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        group.name ?? '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.grey,
                                        backgroundImage:
                                            (deptor.avatar != null &&
                                                deptor
                                                    .avatar!
                                                    .publicUrl
                                                    .isNotEmpty)
                                            ? NetworkImage(
                                                deptor.avatar!.publicUrl,
                                              )
                                            : NetworkImage(
                                                'https://ui-avatars.com/api/?name=${Uri.encodeComponent(deptor.fullName ?? 'User')}&background=random&color=fff&size=128',
                                              ),
                                      ),
                                      Image.asset(
                                        'lib/assets/icons/money-transfer.png',
                                        width: 50,
                                      ),
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.grey,
                                        backgroundImage:
                                            (creditor.avatar != null &&
                                                creditor
                                                    .avatar!
                                                    .publicUrl
                                                    .isNotEmpty)
                                            ? NetworkImage(
                                                creditor.avatar!.publicUrl,
                                              )
                                            : NetworkImage(
                                                'https://ui-avatars.com/api/?name=${Uri.encodeComponent(creditor.fullName ?? 'User')}&background=random&color=fff&size=128',
                                              ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Column(
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text:
                                              deptor.id !=
                                                  HiveService.getUser().id
                                              ? deptor.fullName
                                              : '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: AppThemes.primary3Color,
                                              ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  deptor.id ==
                                                      HiveService.getUser().id
                                                  ? ' ${intl.youOwn} '
                                                  : ' ${intl.ownYou} ',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodyMedium,
                                            ),
                                            TextSpan(
                                              text:
                                                  creditor.id ==
                                                      HiveService.getUser().id
                                                  ? intl.you
                                                  : creditor.fullName,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        AppThemes.primary3Color,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        ' ${formatNumber(state.depts[index].value)} ${state.depts[index].currency.code}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  deptor.id ==
                                                      HiveService.getUser().id
                                                  ? AppThemes.minusMoney
                                                  : AppThemes.successColor,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomButton(
                                        text: intl.detail,
                                        onPressed: () {},
                                        size: ButtonSize.medium,
                                        type: ButtonType.secondary,
                                        customColor: AppThemes.infoColor,
                                      ),
                                      CustomButton(
                                        text:
                                            deptor.id ==
                                                HiveService.getUser().id
                                            ? intl.pay
                                            : intl.remind,
                                        onPressed: () {
                                          if (deptor.id ==
                                              HiveService.getUser().id) {
                                            showSettleUpDialog(
                                              context: context,
                                              receiver: creditor,
                                              amount: state.depts[index].value
                                                  .toDouble(),
                                              currency:
                                                  state.depts[index].currency,
                                              groupId: group.id ?? '',
                                            );
                                          } else {
                                            // Xử lý nhắc nhở
                                          }
                                        },
                                        size: ButtonSize.medium,
                                        customColor:
                                            deptor.id ==
                                                HiveService.getUser().id
                                            ? AppThemes.minusMoney
                                            : AppThemes.successColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
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

  Future<void> showFriendRequestDialog(
    BuildContext context,
    AppLocalizations intl,
    UserModel friend,
  ) {
    return showCustomDialog(
      context: context,
      label: intl.friendRequest(intl.you),
      content: Column(
        children: [
          _buildUserRow(friend),
          const SizedBox(height: 8),
          CustomTextInputWidget(
            size: TextInputSize.large,
            controller: controller,
            keyboardType: TextInputType.text,
            isReadOnly: false,
            label: intl.addFriendMessage,
          ),
          const SizedBox(height: 8),
          _buildActionButtons(intl, friend),
        ],
      ),
    );
  }

  Widget _buildUserRow(UserModel friend) {
    final currentUser = HiveService.getUser();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _userAvaAndName(
          currentUser.avatarUrl,
          AppLocalizations.of(context)!.you,
        ),
        const SizedBox(width: 8),
        Image.asset('lib/assets/images/arrow_image.png', width: 50),
        const SizedBox(width: 8),
        _userAvaAndName(friend.avatar, friend.fullName?.split(' ').last),
      ],
    );
  }

  Widget _buildActionButtons(AppLocalizations intl, UserModel friend) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CustomButton(
          text: intl.cancel,
          onPressed: () {
            Navigator.of(context).pop();
          },
          size: ButtonSize.medium,
          type: ButtonType.secondary,
          customColor: AppThemes.errorColor,
        ),
        CustomFormWrapper(
          fields: [FormFieldConfig(controller: controller, isRequired: true)],
          builder: (isValid) => CustomButton(
            text: intl.send,
            onPressed: (controller.text.isEmpty)
                ? null
                : () {
                    context.read<FriendBloc>().add(
                      SendFriendRequestEvent(
                        friend.id ?? '',
                        message: controller.text.isEmpty
                            ? null
                            : controller.text,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
            size: ButtonSize.medium,
            customColor: AppThemes.primary3Color,
          ),
        ),
      ],
    );
  }

  Widget _userAvaAndName(ImageModel? ava, String? name) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
          backgroundImage: (ava != null && ava.publicUrl.isNotEmpty)
              ? NetworkImage(ava.publicUrl)
              : NetworkImage(
                  'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name ?? 'User')}&background=random&color=fff&size=128',
                ),
        ),
        const SizedBox(height: 4),
        Text(
          name ?? '',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
