import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/friend/data/models/friend_model.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_event.dart';
import 'package:Dividex/features/image/data/models/image_model.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/info_card.dart';
import 'package:Dividex/shared/widgets/show_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum FriendCardType { none, response, pending, acepted }

class FriendCard extends StatefulWidget {
  const FriendCard({super.key, required this.friend, this.type, this.isSearchPage = false});

  final FriendModel friend;
  final FriendCardType? type;
  final bool isSearchPage;

  @override
  State<FriendCard> createState() => _FriendCardState();
}

class _FriendCardState extends State<FriendCard> {
  final controller = TextEditingController();
  final currentUser = HiveService.getUser();

  @override
  void initState() {
    super.initState();
    controller.text = widget.friend.messageRequest ?? '';
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return InfoCard(
      title: widget.friend.fullName,
      subtitle: widget.friend.info ?? widget.friend.messageRequest,
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.grey,
        backgroundImage:
            (widget.friend.avatarUrl != null &&
                widget.friend.avatarUrl!.publicUrl.isNotEmpty)
            ? NetworkImage(widget.friend.avatarUrl!.publicUrl)
            : NetworkImage(
                'https://ui-avatars.com/api/?name=${Uri.encodeComponent(widget.friend.fullName)}&background=random&color=fff&size=128',
              ),
      ),
      onTap: () {
        // Navigate to friend's profile
        print('Navigate to ${widget.friend.fullName} profile');
      },
      trailing: IconButton(
        icon: _buildTrailingIcon(intl),
        onPressed: () => _handleAction(context, intl),
      ),
    );
  }

  Widget _buildTrailingIcon(AppLocalizations intl) {
    switch (widget.type) {
      case FriendCardType.acepted:
        return const Icon(
          Icons.chevron_right_outlined,
          color: AppThemes.primary3Color,
        );
      case FriendCardType.pending:
      case FriendCardType.response:
        return const Icon(
          Icons.more_horiz_outlined,
          color: AppThemes.primary3Color,
        );
      case FriendCardType.none:
        return CustomButton(
          text: intl.add,
          onPressed: () {
            _handleAction(context, intl);
          },
          size: ButtonSize.small,
        );
      default:
        return const SizedBox();
    }
  }

  void _handleAction(BuildContext context, AppLocalizations intl) {
    switch (widget.type) {
      case FriendCardType.acepted:
        // Navigate to friend's profile
        break;
      case FriendCardType.none:
        if (widget.isSearchPage) {
          showFriendRequestDialog(context, intl, FriendCardType.none);
        }
        break;
      case FriendCardType.response:
      case FriendCardType.pending:
        if (!widget.isSearchPage) {
          showFriendRequestDialog(context, intl, widget.type ?? FriendCardType.none);
        }
        break;
      default:
        break;
    }
  }

  Future<void> showFriendRequestDialog(
    BuildContext context,
    AppLocalizations intl,
    FriendCardType type,
  ) {
    final isReceived = type == FriendCardType.response;
    final isSent = type == FriendCardType.pending;
    final isUser = type == FriendCardType.none;

    return showCustomDialog(
      context: context,
      label: intl.friendRequest(
        isReceived ? widget.friend.fullName : (currentUser.fullName ?? ''),
      ),
      content: Column(
        children: [
          _buildUserRow(isUser),
          const SizedBox(height: 8),
          CustomTextInputWidget(
            size: TextInputSize.large,
            controller: controller,
            keyboardType: TextInputType.text,
            isReadOnly: !isUser,
            label: intl.addFriendMessage,
          ),
          const SizedBox(height: 8),
          _buildActionButtons(intl, isReceived, isSent, isUser),
        ],
      ),
    );
  }

  Widget _buildUserRow(bool isUser) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _userAvaAndName(
          isUser ? currentUser.avatarUrl : widget.friend.avatarUrl,
          isUser ? AppLocalizations.of(context)!.you : widget.friend.fullName,
        ),
        const SizedBox(width: 8),
        Image.asset('lib/assets/images/arrow_image.png', width: 50),
        const SizedBox(width: 8),
        _userAvaAndName(
          isUser ? widget.friend.avatarUrl : currentUser.avatarUrl,
          isUser ? widget.friend.fullName : AppLocalizations.of(context)!.you,
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    AppLocalizations intl,
    bool isReceived,
    bool isSent,
    bool isUser,
  ) {
    if (isReceived) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomButton(
            text: intl.decline,
            onPressed: () {
              context.read<FriendBloc>().add(
                DeclineFriendRequestEvent(widget.friend.friendshipUid ?? ''),
              );
            },
            size: ButtonSize.medium,
            customColor: AppThemes.errorColor,
          ),
          CustomButton(
            text: intl.accept,
            onPressed: () {
              context.read<FriendBloc>().add(
                AcceptFriendRequestEvent(widget.friend.friendshipUid ?? ''),
              );
            },
            size: ButtonSize.medium,
            customColor: AppThemes.successColor,
          ),
        ],
      );
    } else if (isSent) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButton(
            text: intl.cancel,
            onPressed: () {
              context.read<FriendBloc>().add(
                DeclineFriendRequestEvent(widget.friend.friendshipUid ?? ''),
              );
            },
            size: ButtonSize.medium,
            customColor: AppThemes.errorColor,
          ),
        ],
      );
    } else if (isUser) {
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
          CustomButton(
            text: intl.send,
            onPressed: () {
              context.read<FriendBloc>().add(
                SendFriendRequestEvent(
                  widget.friend.friendUid,
                  message: controller.text.isEmpty ? null : controller.text,
                ),
              );
            },
            size: ButtonSize.medium,
            customColor: AppThemes.primary3Color,
          ),
        ],
      );
    }
    return const SizedBox();
  }

  Widget _userAvaAndName(ImageModel? ava, String? name) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
        radius: 30,
        backgroundColor: Colors.grey,
        backgroundImage:
            (ava != null && ava.publicUrl.isNotEmpty)
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
