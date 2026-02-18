import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:flutter/material.dart';

class SquareUser extends StatefulWidget {
  final UserModel user;
  final Function()? onTap;
  final bool isSelected;

  const SquareUser({
    super.key,
    required this.user,
    this.onTap,
    this.isSelected = false,
  });

  @override
  State<SquareUser> createState() => _SquareUserState();
}

class _SquareUserState extends State<SquareUser> {
  late bool isSelected;
  
  @override
  void initState() {
    super.initState();
    isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
        widget.onTap?.call();
      },
      child: SizedBox(
        width: 100,
        height: 100,
        child: Material(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
              ? AppThemes.primary4Color
              : Colors.white,
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
                          color: isSelected
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
