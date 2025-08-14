import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddButton extends StatefulWidget {
  const AddButton({super.key});

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          // Nút chính
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Icon(_isExpanded ? Icons.close : Icons.add),
            ),
          ),
      
          // Các nút con
          if (_isExpanded) ...[
            Positioned(
              bottom: 80.0, // Khoảng cách từ nút chính
              right: 16.0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppThemes.primary3Color,
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Column(
                  children: [
                    Tooltip(
                      message: intl.addExpense, // Sử dụng intl để lấy chuỗi
                      preferBelow: false, // Hiển thị tooltip bên trên
                      child: FloatingActionButton(
                        onPressed: () {
                          context.pushNamed(AppRouteNames.addExpense, extra: 0);
                        },
                        heroTag: 'expenseButton',
                        backgroundColor: Colors.transparent,
                        elevation: 0, // 🔹 Tắt shadow
                        highlightElevation: 0, // 🔹 Tắt shadow khi nhấn
                        child: const Icon(Icons.attach_money_outlined),
                      ),
                    ),
                    const SizedBox(height: 8.0), // Khoảng cách giữa các nút
                    Tooltip(
                      message: intl.addEvent, // Sử dụng intl để lấy chuỗi
                      preferBelow: false, // Hiển thị tooltip bên trên
                      child: FloatingActionButton(
                        onPressed: () {
                          context.pushNamed(AppRouteNames.addEvent, extra: 0);
                        },
                        heroTag: 'eventButton',
                        backgroundColor: Colors.transparent,
                        elevation: 0, // 🔹 Tắt shadow
                        highlightElevation: 0, // 🔹 Tắt shadow khi nhấn
                        child: const Icon(Icons.event),
                      ),
                    ),
                    const SizedBox(height: 8.0), // Khoảng cách giữa các nút
                    Tooltip(
                      message: intl.addGroup, // Sử dụng intl để lấy chuỗi
                      preferBelow: false, // Hiển thị tooltip bên trên
                      child: FloatingActionButton(
                        onPressed: () {
                          context.pushNamed(AppRouteNames.addGroup, extra: 0);
                        },
                        heroTag: 'groupButton',
                        backgroundColor: Colors.transparent,
                        elevation: 0, // 🔹 Tắt shadow
                        highlightElevation: 0, // 🔹 Tắt shadow khi nhấn
                        child: const Icon(Icons.group),
                      ),
                    ),
                  ],
                ),
              ),
            ), 
          ],
        ],
      ),
    );
  }
}
