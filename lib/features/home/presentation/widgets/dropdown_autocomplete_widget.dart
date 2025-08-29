import 'dart:async';

import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/category_bloc.dart'
    as category_event;
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryAutocompleteWidget extends StatefulWidget {
  final Function(String?) onCategorySelected;
  const CategoryAutocompleteWidget({
    super.key,
    required this.onCategorySelected,
  });

  @override
  State<CategoryAutocompleteWidget> createState() =>
      _CategoryAutocompleteWidgetState();
}

class _CategoryAutocompleteWidgetState
    extends State<CategoryAutocompleteWidget> {
  final ValueNotifier<String?> _selectedCategory = ValueNotifier(null);
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: _selectedCategory,
      builder: (context, value, _) {
        return BlocListener<category_event.LoadedCategoriesBloc, category_event.LoadedCategoriesState>(
          listener: (context, state) {
            setState(() {}); // ép Autocomplete rebuild để nhận list mới
          },
          child: Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              final blocState = context
                  .read<category_event.LoadedCategoriesBloc>()
                  .state;

              if (textEditingValue.text.isEmpty) {
                return blocState.categories;
              }
              return blocState.categories.where(
                (category) => category.toLowerCase().contains(
                  textEditingValue.text.toLowerCase(),
                ),
              );
            },
            onSelected: widget.onCategorySelected,
            fieldViewBuilder:
                (context, controller, focusNode, onEditingComplete) {
                  controller.removeListener(() {}); // clear trước
                  controller.addListener(() {
                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                    _debounce = Timer(const Duration(milliseconds: 100), () {
                      final keyword = controller.text.trim();
                      if (keyword.isNotEmpty) {
                        context.read<category_event.LoadedCategoriesBloc>().add(
                          category_event.RefreshCategoriesEvent(
                            key: keyword,
                            page: 1,
                            pageSize: 5,
                          ),
                        );
                      }
                    });
                  });

                  return CustomTextInput(
                    controller: controller,
                    label: AppLocalizations.of(context)!.expenseCategoryLabel,
                    focusNode: focusNode,
                    onEditingComplete: onEditingComplete,
                  );
                },
          ),
        );
      },
    );
  }
}
