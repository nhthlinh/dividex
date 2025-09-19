import 'package:flutter/material.dart';

class Layout extends StatelessWidget {
  final String title;
  final Widget child;
  final bool showAvatar; // thêm tùy chọn
  final String? avatarUrl; // url/avatar path
  final bool canBeBack;

  const Layout({
    super.key,
    required this.title,
    required this.child,
    this.showAvatar = false,
    this.avatarUrl,
    this.canBeBack = true,
  });

  @override
  Widget build(BuildContext context) {
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
              children: [
                if (canBeBack)
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
                backgroundColor: Colors.grey[200],
                child: ClipOval(
                  child: Image(
                    image:
                        (avatarUrl != null &&
                            avatarUrl!.isNotEmpty &&
                            Uri.tryParse(avatarUrl!)?.hasAbsolutePath == true)
                        ? NetworkImage(avatarUrl!)
                        : const AssetImage('lib/assets/images/Dividex.png'),
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
