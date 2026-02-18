import 'package:Dividex/features/group/data/models/group_member_model.dart';
import 'package:flutter/material.dart';

class MemberCarousel extends StatefulWidget {
  final List<GroupMemberModel> members;
  final ValueChanged<int> onChanged;
  const MemberCarousel({
    super.key,
    required this.members,
    required this.onChanged,
  });

  @override
  State<MemberCarousel> createState() => _MemberCarouselState();
}

class _MemberCarouselState extends State<MemberCarousel> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.2);
    // viewportFraction < 1 => thấy được avatar 2 bên
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80, // cao hơn để chứa avatar phóng to
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.members.length,
        onPageChanged: (idx) {
          widget.onChanged(idx);
        },
        itemBuilder: (context, idx) {
          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double value = 0.0;
              if (_pageController.position.haveDimensions) {
                value = _pageController.page! - idx;
                value = (1 - (value.abs() * 0.3)).clamp(0.7, 1.0);
              } else {
                // khi mới init thì page chưa có -> avatar đầu tiên phóng to
                value = idx == 0 ? 1.0 : 0.7;
              }

              return Center(
                child: Transform.scale(
                  scale: value,
                  child: Opacity(
                    opacity: value, // càng nhỏ càng mờ (0.0 → trong suốt, 1.0 → rõ nét)
                    child: child,
                  ),
                ),
              );
            },
            child: CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                widget.members[idx].user?.avatar?.publicUrl ??
                    'https://ui-avatars.com/api/?name=${Uri.encodeComponent(widget.members[idx].user?.fullName ?? 'Member')}&background=random&color=fff&size=128',
              ),
            ),
          );
        },
      ),
    );
  }
}
