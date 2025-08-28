import 'package:Dividex/features/event_expense/data/models/event_model.dart';
import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/shared/widgets/custom_dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:Dividex/config/l10n/app_localizations.dart';

class GroupDropdownWidget extends StatefulWidget {
  final List<GroupModel> groups;
  final Function(EventModel?) onChanged;
  final EventModel? initialValue;

  const GroupDropdownWidget({
    super.key,
    required this.groups,
    required this.onChanged,
    this.initialValue,
  });

  @override
  State<GroupDropdownWidget> createState() => _GroupDropdownWidgetState();
}

class _GroupDropdownWidgetState extends State<GroupDropdownWidget> {
  EventModel? _selectedEvent;

  @override
  void initState() {
    super.initState();
    _selectedEvent = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final intl = AppLocalizations.of(context)!;

    // Tạo danh sách các DropdownMenuItem để sử dụng trong Dropdown
    // Bao gồm cả tiêu đề nhóm và các sự kiện con
    final List<DropdownMenuItem<EventModel>> allItems = [];

    // Lặp qua từng nhóm (group)
    for (final group in widget.groups) {
      // Thêm tiêu đề nhóm (đây là một item không thể chọn)
      allItems.add(
        DropdownMenuItem<EventModel>(
          value: null, // Giá trị null để item này không thể chọn
          enabled: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundImage: NetworkImage(group.avatarUrl ?? ''),
                   child: const Icon(Icons.group),
                ),
                const SizedBox(width: 8),
                Text(
                  group.name!,
                  style: theme.textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      );

      // Thêm các sự kiện (event) của nhóm đó vào danh sách
      if (group.events != null) {
        for (final event in group.events!) {
          allItems.add(
            DropdownMenuItem<EventModel>(
              value: event,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 48.0,
                  top: 4.0,
                  bottom: 4.0,
                ), // Padding để lùi vào
                child: Text(
                  event.name!,
                  style: theme.textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        }
      }
    }

    return CustomDropdownWidget( 
      label: intl.expenseEventLabel,
      items: allItems,
      value: _selectedEvent,
      //onChanged: (newValue) => _selectedEvent = newValue,
      onChanged: (newValue) {
        setState(() {
          _selectedEvent = newValue;
          widget.onChanged(newValue);
        });
      },
    );
  }
}
