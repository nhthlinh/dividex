import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:flutter/material.dart';

class SquareIconUser extends StatefulWidget {
  final UserModel user;
  final double size; // total square size
  final Function()? onTap;
  final bool isSelectable;
  final Color? backgroundColor;

  const SquareIconUser({
    super.key,
    required this.user,
    this.size = 100,
    this.onTap,
    this.isSelectable = true,
    this.backgroundColor,
  });

  @override
  State<SquareIconUser> createState() => _SquareIconUserState();
}

class _SquareIconUserState extends State<SquareIconUser> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor = widget.backgroundColor;

    if (isSelected) {
      return const SizedBox.shrink();
    }
    return InkWell(
      onTap: () {
        if (widget.isSelectable) {
          setState(() {
            isSelected = true;
          });
          if (widget.onTap != null) {
            widget.onTap!();
          }
        } else {
          setState(() {
            backgroundColor = AppThemes.primary4Color;
          });
        }
      },
      child: SizedBox(
        width: widget.size,
        height: widget.size + 20,
        child: Material(
          color: backgroundColor ?? Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 240, 240, 240),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          (widget.user.avatar != null &&
                              widget.user.avatar!.publicUrl.isNotEmpty)
                          ? NetworkImage(widget.user.avatar!.publicUrl)
                          : NetworkImage(
                              'https://ui-avatars.com/api/?name=${Uri.encodeComponent(widget.user.fullName ?? 'User')}&background=random&color=fff&size=128',
                            ),
                    ),
                    const SizedBox(height: 8),
                    // Label (allow multi-line, centered)
                    Flexible(
                      child: Text(
                        widget.user.fullName ?? '',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: widget.backgroundColor != null
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                if (widget.isSelectable)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Icon(
                      Icons.close_outlined,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserGrid extends StatelessWidget {
  final List<UserModel> users;
  final double spacing;
  final double itemSize;
  final Function(UserModel)? onTap;
  final bool isSelectable;

  const UserGrid({
    super.key,
    required this.users,
    this.spacing = 12,
    this.itemSize = 100,
    this.onTap,
    this.isSelectable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: users
          .map(
            (user) => SquareIconUser(
              key: ValueKey(user.id),
              user: user,
              size: itemSize,
              onTap: onTap != null ? () => onTap!(user) : null,
              isSelectable: isSelectable,
            ),
          )
          .toList(),
    );
  }
}
