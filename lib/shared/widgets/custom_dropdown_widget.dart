// DONE

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:Dividex/config/themes/app_theme.dart';

class CustomDropdownWidget<T> extends StatefulWidget {
  final String label;
  final T? value;
  final List<T> options;
  final void Function(T?) onChanged;
  final bool isRequired;

  /// Hàm build widget cho từng option
  final Widget Function(T item, bool selected) buildOption;

  /// Hàm build widget khi hiển thị trong ô dropdown (sau khi chọn xong)
  final String Function(T item) displayString;

  const CustomDropdownWidget({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    required this.buildOption,
    required this.displayString,
    this.isRequired = false,
  });

  @override
  State<CustomDropdownWidget<T>> createState() =>
      _CustomDropdownWidgetState<T>();
}

class _CustomDropdownWidgetState<T> extends State<CustomDropdownWidget<T>> {
  late TextEditingController searchController = TextEditingController();
  late List<T> filteredOptions;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    filteredOptions = List.from(widget.options);
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            void onSearchChanged(String val) {
              // Cancel timer cũ nếu user gõ liên tục
              if (_debounce?.isActive ?? false) _debounce!.cancel();

              _debounce = Timer(const Duration(milliseconds: 500), () {
                setStateDialog(() {
                  filteredOptions = widget.options
                      .where(
                        (opt) => widget
                            .displayString(opt)
                            .toLowerCase()
                            .contains(val.toLowerCase()),
                      )
                      .toList();
                });
              });
            }

            return Dialog(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), 
              ),
              child: SizedBox(
                height: 400,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      buildDialogHeader(context),

                      const SizedBox(height: 12),

                      // Search box
                      TextField(
                        controller: searchController,
                        onChanged: onSearchChanged,
                        decoration: inputDeco().copyWith(
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppThemes.borderColor),
                          prefixIcon: const Icon(Icons.search),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 0,
                          ),
                        ),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0,
                            ),
                      ),

                      const SizedBox(height: 12),

                      // List options
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            children: filteredOptions.map((opt) {
                              final bool selected = widget.value == opt;
                              return InkWell(
                                onTap: () {
                                  widget.onChanged(opt);
                                  Navigator.pop(context);
                                },
                                child: widget.buildOption(opt, selected),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Stack buildDialogHeader(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: Text(
            widget.label,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        Positioned(
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width < 340
        ? MediaQuery.of(context).size.width - 32
        : 340;

    return SizedBox(
      width: width.toDouble(),
      child: GestureDetector(
        onTap: () => _showPopup(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildLabel(context),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: InputDecorator(
                decoration: inputDeco(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.value != null
                          ? widget.displayString(widget.value as T)
                          : "-- --",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0,
                        height:
                            24 /
                            Theme.of(context).textTheme.bodySmall!.fontSize!,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  RichText buildLabel(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: widget.label,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontSize: 12,
          letterSpacing: 0,
          height: 16 / 12,
          color: Colors.grey,
        ),
        children: widget.isRequired
            ? [
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppThemes.primary3Color),
                ),
              ]
            : [],
      ),
    );
  }

  InputDecoration inputDeco() {
    return InputDecoration(
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: AppThemes.borderColor, width: 1),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: AppThemes.borderColor, width: 1),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: AppThemes.primary3Color, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

}
