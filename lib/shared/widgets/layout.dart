import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:flutter/material.dart';

class Layout extends StatelessWidget {
  final String title;
  final Widget child;
  final bool showAvatar; // thêm tùy chọn
  final String? avatarUrl; // url/avatar path
  final bool canBeBack;
  final Widget? action;
  final bool isHomePage;

  const Layout({
    super.key,
    required this.title,
    required this.child,
    this.showAvatar = false,
    this.avatarUrl,
    this.canBeBack = true,
    this.action,
    this.isHomePage = false,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = HiveService.getUser();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Gradient nền (cao 140px)
          Container(
            height: showAvatar ? 180 : 140,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFD23B6C), Color(0xFFE25D64)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Title + back button ở y = 50
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (canBeBack)
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    if (isHomePage)
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            (currentUser.avatarUrl != null &&
                                currentUser.avatarUrl!.isNotEmpty)
                            ? NetworkImage(currentUser.avatarUrl!)
                            : null,
                        child:
                            (currentUser.avatarUrl == null ||
                                currentUser.avatarUrl!.isEmpty)
                            ? const Icon(Icons.person, color: Colors.white)
                            : null,
                      ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 250,
                      child: Flexible(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                          maxLines: 2,
                          softWrap: true, // Cho phép xuống dòng
                          overflow: TextOverflow.visible, // Không cắt chữ
                        ),
                      ),
                    ),
                  ],
                ),
                if (action != null) action!,
              ],
            ),
          ),

          // Nội dung bo góc ở y = 120
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: showAvatar ? 160 : 120),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: showAvatar ? 48 : 24,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                ),
                child: Stack(children: [SingleChildScrollView(child: child)]),
              ),
            ),
          ),

          // avatar ở giữa bo góc
          if (showAvatar)
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                backgroundImage: (avatarUrl != null && avatarUrl!.isNotEmpty)
                    ? NetworkImage(avatarUrl!)
                    : null,
                child: (avatarUrl == null || avatarUrl!.isEmpty)
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
              ),
            ),
        ],
      ),
    );
  }
}
