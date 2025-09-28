import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:flutter/material.dart';

class SquareIconUser extends StatelessWidget {
  final UserModel user;
  final double size; // total square size

  const SquareIconUser({
    super.key,
    required this.user,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size + 20,
      child: Material(
        color: Colors.transparent,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar
               CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey,
                backgroundImage:
                    (user.avatar != null && user.avatar!.publicUrl.isNotEmpty)
                    ? NetworkImage(user.avatar!.publicUrl)
                    : NetworkImage(
                        'https://ui-avatars.com/api/?name=${Uri.encodeComponent(user.fullName ?? 'User')}&background=random&color=fff&size=128',
                      ),
              ),
              const SizedBox(height: 8),
              // Label (allow multi-line, centered)
              Flexible(
                child: Text(
                  user.fullName ?? '',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ],
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

  const UserGrid({
    super.key,
    required this.users,
    this.spacing = 12,
    this.itemSize = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: users
          .map((user) => SquareIconUser(user: user, size: itemSize))
          .toList(),
    );
  }
}

