import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/features/friend/data/models/friend_request_model.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_event.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/message_widget.dart';
import 'package:Dividex/shared/widgets/show_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

enum FriendCardType { received, sent, friend, none }

class FriendCard extends StatefulWidget {
  final FriendRequestModel friend;
  final FriendCardType type;

  const FriendCard(this.friend, {super.key, required this.type});

  @override
  State<FriendCard> createState() => _FriendCardState();
}

class _FriendCardState extends State<FriendCard> {
  final TextEditingController _messageController = TextEditingController();
  String currentMessage = '';

  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    currentMessage = widget.friend.messageRequest ?? '';
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    if (!isVisible) {
      return const SizedBox.shrink();
    }

    return Slidable(
      key: ValueKey(widget.friend.friendUid),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          // Chưa là bạn
          if (widget.type == FriendCardType.none)
            SlidableAction(
              onPressed: (context) {
                sendRequest(context, widget.friend, intl);
              },
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.person_add,
              label: intl.addFriend,
            ),
          // Đã nhận lời mời
          if (widget.type == FriendCardType.received) ...[
            SlidableAction(
              onPressed: (context) {
                context.read<FriendBloc>().add(
                  DeclineFriendRequestEvent(widget.friend.friendshipUid ?? ''),
                );
                setState(() {
                  isVisible = false;
                });
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.close,
              label: intl.decline,
            ),
            SlidableAction(
              onPressed: (context) {
                context.read<FriendBloc>().add(
                  AcceptFriendRequestEvent(widget.friend.friendshipUid ?? ''),
                );
                setState(() {
                  isVisible = false;
                });
              },
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.check,
              label: intl.accept,
            ),
          ],

          // Đã gửi lời mời
          if (widget.type == FriendCardType.sent)
            SlidableAction(
              onPressed: (context) {
                context.read<FriendBloc>().add(
                  DeclineFriendRequestEvent(widget.friend.friendshipUid ?? ''),
                );
                setState(() {
                  isVisible = false;
                });
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.hourglass_top,
              label: intl.cancel,
            ),
          // Đã là bạn
          if (widget.type == FriendCardType.friend)
            SlidableAction(
              onPressed: (context) {
                context.read<FriendBloc>().add(
                  DeclineFriendRequestEvent(widget.friend.friendshipUid ?? ''),
                );
                setState(() {
                  isVisible = false;
                });
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.person_remove,
              label: intl.cancel,
            ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 6),
        child: ListTile(
          contentPadding: const EdgeInsets.all(6),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(widget.friend.avatarUrl),
            radius: 25,
            child: const Icon(Icons.person, color: Colors.white),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.friend.fullName,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              if (widget.friend.messageRequest != null)
                Text(
                  widget.friend.messageRequest!,
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void sendRequest(
    BuildContext context,
    FriendRequestModel friend,
    AppLocalizations intl,
  ) {
    final friendBloc = context.read<FriendBloc>();

    showCustomDialog(
      context: context,
      child: Builder(
        builder: (dialogContext) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextInput(
                label: intl.addFriendMessage,
                controller: _messageController,
                hintText: intl.addFriendMessageHint,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButton(
                    isBig: false,
                    buttonText: intl.cancel,
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                  CustomButton(
                    isBig: false,
                    buttonText: intl.save,
                    onPressed: () {
                      if (!mounted) return;
                      setState(() {
                        currentMessage = _messageController.text.trim();
                      });

                      Navigator.of(
                        dialogContext,
                      ).pop(); // 👈 dùng dialogContext

                      friendBloc.add(
                        SendFriendRequestEvent(
                          friend.friendUid,
                          message: currentMessage.isEmpty
                              ? null
                              : currentMessage,
                        ),
                      );

                      showCustomToast(intl.success, type: ToastType.success);
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
