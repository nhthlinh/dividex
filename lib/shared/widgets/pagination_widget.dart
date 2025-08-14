import 'package:flutter/material.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageSelected;

  const PaginationWidget({
    required this.currentPage,
    required this.totalPages,
    required this.onPageSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> pageButtons = [];

    for (int i = 1; i <= totalPages; i++) {
      if (i == 1 ||
          i == totalPages ||
          (i >= currentPage - 1 && i <= currentPage + 1)) {
        pageButtons.add(_buildPageButton(i, context));
      } else if (i == 2 && currentPage > 3) {
        pageButtons.add(
          Text('...', style: Theme.of(context).textTheme.bodySmall),
        );
      } else if (i == totalPages - 1 && currentPage < totalPages - 2) {
        pageButtons.add(
          Text('...', style: Theme.of(context).textTheme.bodySmall),
        );
      }
    }

    return Wrap(
      spacing: 4,
      alignment: WrapAlignment.center,
      children: [
        if (currentPage > 1)
          IconButton(
            icon: const Icon(Icons.keyboard_double_arrow_left),
            onPressed: () {
              onPageSelected(currentPage - 1);
            },
          ),
        ...pageButtons,
        if (currentPage < totalPages)
          IconButton(
            icon: const Icon(Icons.keyboard_double_arrow_right),
            onPressed: () {
              onPageSelected(currentPage + 1);
            },
          ),
      ],
    );
  }

  Widget _buildPageButton(int page, BuildContext context) {
    final isSelected = page == currentPage;
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: isSelected
            ? Theme.of(context).primaryColor
            : Colors.transparent,
        textStyle: Theme.of(context).textTheme.bodySmall,
        foregroundColor: isSelected
            ? Colors.white
            : Theme.of(context).colorScheme.onSurface,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      ),
      onPressed: () => onPageSelected(page),
      child: Text(page.toString()),
    );
  }
}
