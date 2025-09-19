// import 'package:flutter/material.dart';

// class FriendCard extends StatelessWidget {
//   const FriendCard({super.key, required this.user, this.onTap});

//   final UserM user;
//   final VoidCallback? onTap;

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       onTap: onTap,
//       leading: CircleAvatar(
//         backgroundImage: NetworkImage(user.avatarUrl),
//       ),
//       title: Text(user.name),
//       subtitle: Text(user.email),
//       trailing: Icon(Icons.chevron_right),
//     );
//   }