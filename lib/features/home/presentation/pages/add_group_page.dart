import 'package:flutter/material.dart';

class AddGroupPage extends StatelessWidget {
  final int groupId;

  const AddGroupPage({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Group'),
      ),
      body: Center(
        child: Text('Group ID: $groupId'),
      ),
    );
  }
}
