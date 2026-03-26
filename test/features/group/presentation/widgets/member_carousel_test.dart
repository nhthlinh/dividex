import 'package:Dividex/features/group/data/models/group_member_model.dart';
import 'package:Dividex/features/group/presentation/member_carousel.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MemberCarousel renders avatars for members', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MemberCarousel(
            members: <GroupMemberModel>[
              GroupMemberModel(user: UserModel(fullName: 'Alice')),
              GroupMemberModel(user: UserModel(fullName: 'Bob')),
            ],
            onChanged: (_) {},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    while (tester.takeException() != null) {
      // Ignore NetworkImage loading failures in widget tests.
    }

    expect(find.byType(PageView), findsOneWidget);
    expect(find.byType(CircleAvatar), findsWidgets);
  });
}
