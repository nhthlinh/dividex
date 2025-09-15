// import 'dart:async';

// import 'package:flutter/material.dart';

// class AutocompleteWidget<T extends Object> extends StatefulWidget {
//   final Function(T?) onSelected;
//   final List<T> options;
//   final String label;
//   const AutocompleteWidget({
//     super.key,
//     required this.onSelected,
//     required this.options,
//     required this.label,
//   });

//   @override
//   State<AutocompleteWidget<T>> createState() =>
//       _AutocompleteWidgetState<T>();
// }

// class _AutocompleteWidgetState<T extends Object> extends State<AutocompleteWidget<T>> {
//   final ValueNotifier<T?> _selected = ValueNotifier(null);
//   Timer? _debounce;

//   @override
//   void dispose() {
//     _debounce?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<T?>(
//       valueListenable: _selected,
//       builder: (context, value, _) {
//         return Autocomplete<T>(
//           optionsBuilder: (TextEditingValue textEditingValue) {
//             if (textEditingValue.text.isEmpty) {
//               return widget.options;
//             }
//             return widget.options.where(
//               (option) => option.toString().toLowerCase().contains(
//                 textEditingValue.text.toLowerCase(),
//               ),
//             );
//           },
//           onSelected: widget.onSelected,
//           fieldViewBuilder:
//               (context, controller, focusNode, onEditingComplete) {
//                 return CustomTextInput(
//                   controller: controller,
//                   label: widget.label,
//                   focusNode: focusNode,
//                   onEditingComplete: onEditingComplete,
//                 );
//               },
//         );
//       },
//     );
//   }
// }
