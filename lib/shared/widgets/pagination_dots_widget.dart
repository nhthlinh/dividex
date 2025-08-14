import 'package:Dividex/config/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PaginationDots extends StatelessWidget {
  final int i;

  const PaginationDots({super.key, required this.i});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          // 3 chấm tròn
          return GestureDetector(
            onTap: () {
              if (index == 0) {
              }
              else if (index == 1) {
              }
              else if (index == 2) {
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index == i
                    ? Theme.of(context).primaryColor
                    : Colors.grey[400],
              ),
            ),
          );
        }),
      ),
    );
  }
}
