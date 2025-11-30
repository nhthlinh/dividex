import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/home/presentation/widgets/add_button_widget.dart';
import 'package:Dividex/shared/widgets/show_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const AppShell({super.key, required this.child, required this.currentIndex});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final ScrollController _scrollController = ScrollController();
  bool _isBottomNavVisible = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _isRefreshing = false;

  void _triggerRefresh() async {
    if (_isRefreshing) return; // tránh gọi trùng
    
    _isRefreshing = true;

    await _onRefresh();

    await Future.delayed(const Duration(milliseconds: 100));

    _isRefreshing = false;
  }

  Future<void> _onRefresh() async {  
    GoRouter.of(context).refresh();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        if (!_isBottomNavVisible) {
          setState(() => _isBottomNavVisible = true);
        }
      },
      child: Scaffold(
        body: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is UserScrollNotification &&
                notification.direction == ScrollDirection.reverse &&
                _isBottomNavVisible) {
              setState(() => _isBottomNavVisible = false);
            } else if (notification is UserScrollNotification &&
                notification.direction == ScrollDirection.forward &&
                !_isBottomNavVisible) {
              setState(() => _isBottomNavVisible = true);
            }
            if (notification is OverscrollNotification &&
                notification.overscroll < - 10) {
              _triggerRefresh();
            }

            return false;
          },
          child: widget.child,
        ),

        // NavBar sẽ biến mất hoàn toàn => nội dung chiếm full
        bottomNavigationBar: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _isBottomNavVisible
              ? Container(
                  key: const ValueKey("navbar"),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 240, 240, 240),
                        blurRadius: 12,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: BottomAppBar(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    shape: const CircularNotchedRectangle(),
                    notchMargin: 8.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(context, 0, Icons.home, 'Home'),
                        _buildNavItem(context, 1, Icons.search, 'Search'),
                        const SizedBox(width: 60),
                        _buildNavItem(context, 2, Icons.mail_outline, 'Mail'),
                        _buildNavItem(context, 3, Icons.settings_outlined, 'Settings'),
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink(), // khi ẩn thì trả về widget rỗng
        ),

        // FAB cũng ẩn/hiện theo
        floatingActionButton: AnimatedSlide(
          duration: const Duration(milliseconds: 250),
          offset: _isBottomNavVisible ? Offset.zero : const Offset(0, 2),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _isBottomNavVisible ? 1 : 0,
            child: FloatingActionButton(
              onPressed: () {
                showCustomDialog(
                  context: context,
                  content: const AddButtonPopup(),
                );
              },
              backgroundColor: AppThemes.primary3Color,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
  ) {
    final bool isSelected = index == widget.currentIndex;
    return InkWell(
      onTap: () {
        switch (index) {
          case 0:
            context.pushNamed(AppRouteNames.home);
            break;
          case 1:
            context.pushNamed(AppRouteNames.search);
            break;
          case 2:
            context.pushNamed(AppRouteNames.chat);
            break;
          case 3:
            context.pushNamed(AppRouteNames.settings);
            break;
          default:
            break;
        }
      },
      child: Container(
        decoration: isSelected
            ? BoxDecoration(
                color: AppThemes.primary3Color,
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: isSelected ? Colors.white : Colors.grey),
              if (isSelected) ...[
                const SizedBox(width: 4),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isSelected ? Colors.white : Colors.grey,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
