import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/features/group/presentation/bloc/group_bloc.dart';
import 'package:Dividex/features/group/presentation/bloc/group_event.dart'
    as group_event;
import 'package:Dividex/features/home/presentation/widgets/friend_widget.dart';
import 'package:Dividex/features/home/presentation/widgets/group_widget.dart';
import 'package:Dividex/features/user/presentation/bloc/user_bloc.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart'
    as user_event;
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ComunityWidget extends StatefulWidget {
  const ComunityWidget({super.key});

  @override
  State<ComunityWidget> createState() => _ComunityWidgetState();
}

class _ComunityWidgetState extends State<ComunityWidget> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0; // Quản lý trạng thái của PageView

  List<Widget> get _options {
    return [
      BlocProvider(
        create: (context) =>
            LoadedGroupsBloc()
              ..add(group_event.InitialEvent(HiveService.getUser().id ?? '')),
        child: const GroupWidget(),
      ),
      BlocProvider(
        create: (context) => LoadedUsersBloc()
          ..add(
            user_event.InitialEvent(
              HiveService.getUser().id ?? '',
              user_event.LoadUsersAction.getFriends,
            ),
          ),
        child: const FriendWidget(),
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.jumpToPage(_selectedIndex);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    return Column(
      children: [
        NavigationBar(
          selectedIndex: _selectedIndex, // Thêm dòng này để cập nhật trạng thái
          onDestinationSelected:
              _onItemTapped, // Thêm dòng này để xử lý sự kiện
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.group),
              label: intl.group,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person),
              label: intl.friend,
            ),
          ],
        ),
        Expanded(
          // Sử dụng Expanded để PageView chiếm hết không gian còn lại
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            physics: const NeverScrollableScrollPhysics(),
            children: _options,
          ),
        ),
      ],
    );
  }
}
