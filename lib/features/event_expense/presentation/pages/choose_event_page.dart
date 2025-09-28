import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/event_expense/data/models/event_model.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/event/event_bloc.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/event/event_event.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/event/event_state.dart';
import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/content_card.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/info_card.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart';

class ChooseEventPage extends StatefulWidget {
  final ValueChanged<EventModel> onSelectedEventChanged;
  final EventModel? initialSelectedEvent;

  const ChooseEventPage({
    super.key,
    required this.onSelectedEventChanged,
    required this.initialSelectedEvent,
  });

  @override
  State<ChooseEventPage> createState() => _ChooseEventPageState();
}

class _ChooseEventPageState extends State<ChooseEventPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<bool> isVisible = [];
  EventModel? selectedEvent;

  @override
  void initState() {
    super.initState();
    selectedEvent = widget.initialSelectedEvent;
    context.read<EventDataBloc>().add(InitialEvent());
  }

  void _toggleEvent(EventModel event) {
    setState(() {
      if (selectedEvent?.id == event.id) {
        selectedEvent = null;
      } else {
        selectedEvent = event;
      }
    });
    widget.onSelectedEventChanged(event);
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AppShell(
      currentIndex: 0,
      child: SimpleLayout(
        title: intl.expenseEventLabel,
        child: Column(
          children: [
            // Search
            CustomTextInputWidget(
              size: TextInputSize.large,
              isReadOnly: false,
              keyboardType: TextInputType.text,
              label: intl.searchTab,
              controller: _searchController,
              suffixIcon: IconButton(
                onPressed: () {
                  context.read<EventDataBloc>().add(
                    InitialEvent(searchQuery: _searchController.text),
                  );
                },
                icon: Icon(Icons.search),
              ),
            ),

            // results
            BlocBuilder<EventDataBloc, EventDataState>(
              buildWhen: (p, c) =>
                  p.groups != c.groups || p.isLoading != c.isLoading,
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(
                    child: ColoredBox(
                      color: Colors.transparent,
                      child: SpinKitFadingCircle(
                        color: AppThemes.primary3Color,
                      ),
                    ),
                  );
                } else if (state.groups.isEmpty) {
                  return noUserWidget(intl, theme);
                }

                final hasMore = state.groups.length < state.totalItems;
                isVisible.addAll(
                  List.generate(state.groups.length, (index) => false),
                );

                return listResults(
                  intl,
                  hasMore,
                  state.totalItems,
                  state.groups,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  LayoutBuilder noUserWidget(AppLocalizations intl, ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(intl.noSearchResults, style: theme.textTheme.titleSmall),
            ],
          ),
        );
      },
    );
  }

  Column listResults(
    AppLocalizations intl,
    bool hasMore,
    int totalGroups,
    List<GroupModel>? groups,
  ) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: intl.result,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 12,
                letterSpacing: 0,
                height: 16 / 12,
                color: Colors.grey,
              ),
              children: totalGroups > 0
                  ? [
                      TextSpan(
                        text: totalGroups > 99 ? ' 99+' : ' $totalGroups',
                        style: TextStyle(color: AppThemes.primary3Color),
                      ),
                    ]
                  : [],
            ),
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: groups?.length != null
              ? (groups!.length + (hasMore ? 1 : 0))
              : 0,
          itemBuilder: (context, index) {
            if (index == groups!.length) {
              context.read<EventDataBloc>().add(
                LoadMoreEventsGroups(
                  searchQuery: _searchController.text.isEmpty
                      ? ''
                      : _searchController.text,
                ),
              );
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: SpinKitFadingCircle(color: const Color(0xFF08AE02)),
                ),
              );
            }

            final group = groups[index];

            return Column(
              children: [
                InfoCard(
                  title: group.name ?? '',
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey,
                    backgroundImage:
                        (group.avatarUrl != null && group.avatarUrl!.publicUrl.isNotEmpty)
                        ? NetworkImage(group.avatarUrl!.publicUrl)
                        : NetworkImage(
                            'https://ui-avatars.com/api/?name=${Uri.encodeComponent(group.name ?? 'Group')}&background=random&color=fff&size=128',
                          ),
                  ),
                  onTap: () {
                    isVisible[index] = !isVisible[index];
                    setState(() {});
                  },
                  trailing: isVisible[index]
                      ? const Icon(Icons.keyboard_arrow_up)
                      : const Icon(Icons.keyboard_arrow_down),
                ),

                if (isVisible[index])
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      children: group.events != null && group.events!.isNotEmpty
                          ? group.events!.map((event) {
                              final isSelected = event.id == selectedEvent?.id;

                              return ContentCard(
                                onTap: () => _toggleEvent(event),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.event,
                                      color: isSelected
                                          ? AppThemes.primary3Color
                                          : Colors.grey,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            event.name ?? '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          Text(
                                            '${event.eventStart != null ? DateFormat('dd/MM/yyyy').format(event.eventStart!) : ''} - ${event.eventEnd != null ? DateFormat('dd/MM/yyyy').format(event.eventEnd!) : ''}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      AppThemes.primary3Color,
                                                ),
                                          ),
                                          if (event.description != null) ...[
                                            const SizedBox(height: 4),
                                            Text(
                                              event.description!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: Colors.grey[600],
                                                  ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    if (isSelected)
                                      const Icon(
                                        Icons.check_circle,
                                        color: AppThemes.primary3Color,
                                      ),
                                  ],
                                ),
                              );

                              // return InfoCard(
                              //   title: event.name ?? '',
                              //   subtitle: event.description ?? '',
                              //   leading: Icon(
                              //     Icons.event,
                              //     color: isSelected
                              //         ? AppThemes.primary3Color
                              //         : Colors.grey,
                              //   ),
                              //   onTap: () {
                              //     _toggleEvent(event);
                              //   },
                              //   trailing: isSelected
                              //       ? const Icon(
                              //           Icons.check_circle,
                              //           color: AppThemes.primary3Color,
                              //         )
                              //       : null,
                              // );
                            }).toList()
                          : [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: Text(
                                  intl.noEventsInGroup,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: Colors.grey),
                                ),
                              ),
                            ],
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
