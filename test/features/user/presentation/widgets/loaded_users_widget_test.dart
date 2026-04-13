import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders user full name in a user tile widget', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: _UserNameTile(user: UserModel(id: 'u-1', fullName: 'Alice')),
        ),
      ),
    );

    expect(find.text('Alice'), findsOneWidget);
  });
}

class _UserNameTile extends StatelessWidget {
  const _UserNameTile({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.fullName ?? ''),
      subtitle: Text(user.id ?? ''),
    );
  }
}
