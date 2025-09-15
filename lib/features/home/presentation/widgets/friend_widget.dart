// import 'package:Dividex/config/l10n/app_localizations.dart';
// import 'package:Dividex/config/themes/app_theme.dart';
// import 'package:Dividex/features/friend/data/models/friend_request_model.dart';
// import 'package:Dividex/features/friend/domain/usecase.dart';
// import 'package:Dividex/features/friend/presentation/bloc/friend_bloc.dart';
// import 'package:Dividex/features/friend/presentation/bloc/friend_event.dart';
// import 'package:Dividex/features/friend/presentation/bloc/friend_request_bloc.dart'
//     as request_bloc;
// import 'package:Dividex/features/friend/presentation/bloc/friend_state.dart';
// import 'package:Dividex/features/friend/presentation/bloc/search_users_bloc.dart'
//     as search_bloc;
// import 'package:Dividex/features/home/presentation/widgets/friend_card_widget.dart';
// import 'package:Dividex/shared/services/local/hive_service.dart';
// import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class FriendWidget extends StatefulWidget {
//   const FriendWidget({super.key});

//   @override
//   State<FriendWidget> createState() => _FriendWidgetState();
// }

// class _FriendWidgetState extends State<FriendWidget> {
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState(); 
//     context.read<LoadedFriendsBloc>().add(
//       InitialEvent(HiveService.getUser().id),
//     );
//     context.read<search_bloc.SearchUsersBloc>().add(
//       InitialEvent(HiveService.getUser().id),
//     );
//     context.read<request_bloc.FriendRequestBloc>().add(
//       request_bloc.InitialEvent(
//         type: FriendRequestType.received,
//         HiveService.getUser().id,
//       ),
//     );
//     context.read<request_bloc.FriendRequestBloc>().add(
//       request_bloc.InitialEvent(
//         type: FriendRequestType.sent,
//         HiveService.getUser().id,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final intl = AppLocalizations.of(context)!;

//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           CustomTextInput(
//             label: intl.searchTab,
//             controller: _searchController,
//             suffixIcon: IconButton(
//               onPressed: () {
//                 if (_searchController.text.isNotEmpty) {
//                   context.read<search_bloc.SearchUsersBloc>().add(
//                     InitialEvent(
//                       HiveService.getUser().id,
//                       searchQuery: _searchController.text.isEmpty
//                           ? null
//                           : _searchController.text,
//                     ),
//                   );
//                 }
//                 setState(() {});
//               },
//               icon: Icon(Icons.search),
//             ),
//           ),
//           if (_searchController.text.isNotEmpty) ...[
//             BlocBuilder<search_bloc.SearchUsersBloc, LoadedFriendsState>(
//               buildWhen: (p, c) =>
//                   p.requests != c.requests || p.isLoading != c.isLoading,
//               builder: (context, searchState) {
//                 if (searchState.isLoading) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (searchState.requests.isEmpty) {
//                   return Center(
//                     child: Column(
//                       children: [
//                         const SizedBox(height: 16),
//                         Icon(
//                           Icons.person_search,
//                           size: 64,
//                           color: Colors.grey[400],
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           intl.noSearchResults,
//                           style: Theme.of(context).textTheme.titleSmall,
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           intl.tryDifferentKeyword,
//                           style: Theme.of(
//                             context,
//                           ).textTheme.bodySmall!.copyWith(color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
    
//                 return friendCardList(
//                   intl.result,
//                   context,
//                   searchState.requests,
//                   FriendCardType.none,
//                 );
//               },
//             ),
//           ] else ...[
//             BlocBuilder<request_bloc.FriendRequestBloc, LoadedFriendRequestsState>(
//               key: const ValueKey("receivedRequests"),
//               buildWhen: (p, c) =>
//                   p.received != c.received || p.isLoading != c.isLoading,
//               builder: (context, state) {
//                 return friendRequestList(
//                   intl.received,
//                   FriendRequestType.received,
//                 );
//               },
//             ),
//             BlocBuilder<request_bloc.FriendRequestBloc, LoadedFriendRequestsState>(
//               key: const ValueKey("sentRequests"),
//               buildWhen: (p, c) =>
//                   p.sent != c.sent || p.isLoading != c.isLoading,
//               builder: (context, state) {
//                 return friendRequestList(intl.sent, FriendRequestType.sent);
//               },
//             ),
//             BlocBuilder<LoadedFriendsBloc, LoadedFriendsState>(
//               buildWhen: (p, c) =>
//                   p.requests != c.requests || p.isLoading != c.isLoading,
//               builder: (context, state) {
//                 if (state.isLoading) {
//                   return Center(child: CircularProgressIndicator());
//                 }
    
//                 final theme = Theme.of(context);
    
//                 if (state.requests.isEmpty) {
//                   return LayoutBuilder(
//                     builder: (context, constraints) {
//                       return Center(
//                         child: Column(
//                           children: [
//                             const SizedBox(height: 16),
//                             Align(
//                               alignment: Alignment.centerLeft,
//                               child: Text(
//                                 intl.friend,
//                                 style: Theme.of(context).textTheme.titleMedium
//                                     ?.copyWith(
//                                       color: AppThemes.primary3Color,
//                                     ),
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Icon(
//                               Icons.person_add,
//                               size: 64,
//                               color: Colors.grey[400],
//                             ),
//                             const SizedBox(height: 16),
//                             Text(
//                               intl.noFriends,
//                               style: theme.textTheme.titleSmall,
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               intl.addFirstFriend,
//                               style: theme.textTheme.bodySmall!.copyWith(
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   );
//                 }
    
//                 return friendCardList(
//                   intl.friend,
//                   context,
//                   state.requests,
//                   FriendCardType.friend,
//                 );
//               },
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget friendRequestList(String label, FriendRequestType type) {
//     return BlocBuilder<request_bloc.FriendRequestBloc, LoadedFriendRequestsState>(
//       builder: (context, state) {
//         if (state.isLoading) {
//           return Center(child: CircularProgressIndicator());
//         }

//         final List<FriendRequestModel> requests = type == FriendRequestType.received
//             ? state.received
//             : state.sent;

//         if (requests.isEmpty) {
//           return const SizedBox.shrink();
//         }

//         return friendCardList(
//           label,
//           context,
//           requests,
//           type == FriendRequestType.received
//               ? FriendCardType.received
//               : FriendCardType.sent,
//         );
//       },
//     );
//   }

//   Column friendCardList(
//     String label,
//     BuildContext context,
//     List<FriendRequestModel>? friends,
//     FriendCardType type,
//   ) {
//     return Column(
//       children: [
//         const SizedBox(height: 8),
//         Align(
//           alignment: Alignment.centerLeft,
//           child: Text(
//             label,
//             style: Theme.of(
//               context,
//             ).textTheme.titleMedium?.copyWith(color: AppThemes.primary3Color),
//           ),
//         ),
//         const SizedBox(height: 4),
//         ListView.builder(
//           padding: EdgeInsets.zero,
//           shrinkWrap: true,
//           physics: const AlwaysScrollableScrollPhysics(),
//           itemCount: friends?.length ?? 0,
//           itemBuilder: (context, index) {
//             final friend = friends![index];

//             return BlocProvider(
//               create: (context) => FriendBloc(),
//               child: FriendCard(friend, type: type),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
