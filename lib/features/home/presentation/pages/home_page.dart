// import 'package:Dividex/config/l10n/app_localizations.dart';
// import 'package:Dividex/features/friend/domain/usecase.dart';
// import 'package:Dividex/features/friend/presentation/bloc/friend_bloc.dart';
// import 'package:Dividex/features/friend/presentation/bloc/friend_event.dart';
// import 'package:Dividex/features/friend/presentation/bloc/friend_request_bloc.dart'
//     as request_bloc;
// import 'package:Dividex/features/friend/presentation/bloc/search_users_bloc.dart'
//     as search_bloc;
// import 'package:Dividex/features/group/presentation/bloc/group_bloc.dart';
// import 'package:Dividex/features/group/presentation/bloc/group_event.dart'
//     as group_event;
// import 'package:Dividex/features/home/presentation/bloc/bottom_nav_visibility_cubit.dart';
// import 'package:Dividex/features/home/presentation/pages/setting_sheet.dart';
// import 'package:Dividex/features/home/presentation/widgets/add_button_widget.dart';
// import 'package:Dividex/features/home/presentation/widgets/friend_widget.dart';
// import 'package:Dividex/features/home/presentation/widgets/group_widget.dart';
// import 'package:Dividex/features/home/presentation/widgets/home_widget.dart';
// import 'package:Dividex/shared/services/local/hive_service.dart';
// import 'package:Dividex/shared/widgets/wave_painter.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// int unreadCount = 0; // Đếm số thông báo chưa đọc

// class HomePage extends StatefulWidget {
//   final int selectedIndex;
//   const HomePage({super.key, required this.selectedIndex});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int popIndex = 0; // Để quản lý trạng thái của setting sheet
//   int _selectedIndex = 0; // Để quản lý trạng thái của Bottom Navigation Bar
//   final ScrollController _scrollController = ScrollController();
//   bool _isBottomNavVisible = true;
//   String? avatar;
//   String userId = '';

//   final PageController _pageController = PageController();

//   // Danh sách các màn hình (ví dụ)
//   static final List<Widget> _options = <Widget>[
//     BlocProvider(
//       create: (context) =>
//           LoadedFriendsBloc()..add(InitialEvent(HiveService.getUser().id)),
//       child: const HomeWidget(),
//     ),
//     const SizedBox.shrink(),
//     BlocProvider(
//       create: (context) =>
//           LoadedGroupsBloc()
//             ..add(group_event.InitialEvent(HiveService.getUser().id ?? '')),
//       child: const GroupWidget(),
//     ),
//     MultiBlocProvider(
//       providers: [
//         BlocProvider<LoadedFriendsBloc>(
//           create: (context) => LoadedFriendsBloc(),
//         ),
//         BlocProvider<search_bloc.SearchUsersBloc>(
//           create: (context) => search_bloc.SearchUsersBloc(),
//         ),
//         BlocProvider<request_bloc.FriendRequestBloc>(
//           key: const ValueKey("receivedRequests"),
//           create: (_) => request_bloc.FriendRequestBloc()
//         ),
//         BlocProvider<request_bloc.FriendRequestBloc>(
//           key: const ValueKey("sentRequests"),
//           create: (_) => request_bloc.FriendRequestBloc()
//         ),
//       ],
//       child: const FriendWidget(),
//     ),
//     const SizedBox.shrink(),
//   ];

//   void _onItemTapped(int index) {
//     if (index == 4) {
//       _showSettingsSheet(context);
//       return;
//     }

//     _pageController.jumpToPage(index);
//     popIndex = index;
//   }

//   void _showSettingsSheet(BuildContext context) {
//     showGeneralDialog(
//       context: context,
//       barrierDismissible: true, // Cho phép chạm bên ngoài để đóng
//       barrierLabel: 'Menu', // Nhãn cho lớp phủ barrier
//       barrierColor: const Color.fromARGB(66, 0, 0, 0), // Màu của lớp phủ làm mờ
//       transitionDuration: const Duration(
//         milliseconds: 300,
//       ), // Thời gian chuyển động
//       pageBuilder: (context, animation, secondaryAnimation) {
//         return Align(
//           alignment: Alignment.topRight, // Đặt dialog ở bên trái
//           child: Material(
//             color: Colors
//                 .transparent, // Giúp nội dung không bị ảnh hưởng bởi Material mặc định
//             child: SettingsSheet(userId: userId), // Widget cài đặt của bạn
//           ),
//         );
//       },
//       transitionBuilder: (context, animation, secondaryAnimation, child) {
//         // Hoạt ảnh trượt từ trái sang
//         final offsetAnimation = Tween<Offset>(
//           begin: const Offset(1.0, 0.0),
//           end: Offset.zero, // Kết thúc ở vị trí của nó
//         ).animate(animation);

//         return SlideTransition(position: offsetAnimation, child: child);
//       },
//     ).then((_) {
//       setState(() {
//         _selectedIndex = popIndex; // Cập nhật lại index khi đóng dialog
//       });
//     });
//   }

//   @override
//   void initState() {
//     super.initState();

//     _selectedIndex = widget.selectedIndex; // Đặt index ban đầu từ tham số

//     _scrollController.addListener(() {
//       final direction = _scrollController.position.userScrollDirection;

//       if (direction == ScrollDirection.reverse && _isBottomNavVisible) {
//         setState(() => _isBottomNavVisible = false);
//       } else if (direction == ScrollDirection.forward && !_isBottomNavVisible) {
//         setState(() => _isBottomNavVisible = true);
//       }
//     });

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _pageController.jumpToPage(_selectedIndex); // hoặc số nào bạn muốn
//     });
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();

//     userId = HiveService.getUser().id ?? '';
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final intl = AppLocalizations.of(
//       context,
//     )!; // Lấy đối tượng AppLocalizations

//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             // Logo/Biểu tượng bên trái
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   _pageController.jumpToPage(0);
//                 });
//               },
//               child: Image.asset(
//                 'lib/assets/images/Dividex.png',
//                 width: 100,
//                 height: 40,
//               ),
//             ),
//             CircleAvatar(
//               backgroundImage: NetworkImage(
//                 HiveService.getUser().avatarUrl ?? '',
//               ),
//               radius: 25,
//               child: const Icon(Icons.person),
//             ),
//           ],
//         ),
//       ),
//       body: Stack(
//         children: [
//           Positioned(
//             bottom: 0, // Hoặc top: 0 nếu muốn ở đầu
//             left: 0,
//             right: 0,
//             child: SizedBox(
//               height: 200, // Chiều cao gợn sóng
//               child: CustomPaint(painter: WavePainter()),
//             ),
//           ),
//           PageView(
//             controller: _pageController,
//             onPageChanged: (index) {
//               setState(() {
//                 _selectedIndex = index;
//               });
//             },
//             physics: const NeverScrollableScrollPhysics(),
//             children: _options, // nếu muốn chỉ điều khiển qua bottom nav
//           ),
//         ],
//       ),
//       floatingActionButton: const AddButton(),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//       bottomNavigationBar: BlocBuilder<BottomNavVisibilityCubit, bool>(
//         builder: (context, isVisible) {
//           return AnimatedSwitcher(
//             duration: const Duration(milliseconds: 300),
//             child: isVisible
//                 ? BottomNavigationBar(
//                     key: const ValueKey(
//                       'visibleNav',
//                     ), // để AnimatedSwitcher hoạt động chính xác
//                     items: <BottomNavigationBarItem>[
//                       BottomNavigationBarItem(
//                         icon: const Icon(Icons.home),
//                         label: intl.appTitleHome,
//                       ),
//                       BottomNavigationBarItem(
//                         icon: const Icon(Icons.bar_chart),
//                         label: intl.analytics,
//                       ),
//                       BottomNavigationBarItem(
//                         icon: const Icon(Icons.people),
//                         label: intl.group,
//                       ),
//                       BottomNavigationBarItem(
//                         icon: const Icon(Icons.person),
//                         label: intl.friend,
//                       ),
//                       const BottomNavigationBarItem(
//                         icon: Icon(Icons.menu),
//                         label: 'Menu',
//                       ),
//                     ],
//                     currentIndex: _selectedIndex,
//                     onTap: _onItemTapped,
//                   )
//                 : const SizedBox(
//                     key: ValueKey(
//                       'hiddenNav',
//                     ), // 🔑 để khi ẩn, AnimatedSwitcher nhận biết
//                     height: 0,
//                   ),
//           );
//         },
//       ),
//     );
//   }
// }
