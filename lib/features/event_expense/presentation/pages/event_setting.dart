import 'dart:async';

import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/event/event_bloc.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/event/event_event.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/event/event_state.dart';
import 'package:Dividex/features/event_expense/presentation/widgets/date_input_field_widget.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/presentation/bloc/user_bloc.dart'
    as user_bloc;
import 'package:Dividex/features/user/presentation/bloc/user_event.dart'
    as user_event;
import 'package:Dividex/features/user/presentation/bloc/user_state.dart'
    as user_state;
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/content_card.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/layout.dart';
import 'package:Dividex/shared/widgets/user_grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EventSettingPage extends StatefulWidget {
  final String eventId;
  final String groupId;
  final String eventName;
  const EventSettingPage({
    super.key,
    required this.eventId,
    required this.groupId,
    required this.eventName,
  });

  @override
  State<EventSettingPage> createState() => _EventSettingPageState();
}

class _EventSettingPageState extends State<EventSettingPage> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController eventStartController = TextEditingController();
  final TextEditingController eventEndController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Chọn thêm
  List<UserModel> selectedMembers = [];
  List<String> selectedUserIdsToAdd = [];

  // Gốc
  List<String> members = [];
  List<UserModel> memberModels = [];

  @override
  void initState() {
    super.initState();
    context.read<user_bloc.LoadedUsersBloc>().add(
      user_event.InitialEvent(
        widget.eventId,
        user_event.LoadType.eventParticipants,
        searchQuery: '',
      ),
    );
    context.read<EventBloc>().add(GetEventEvent(eventId: widget.eventId));

    controller.text = widget.eventName;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> updateEvent() async {
    if (controller.text.isNotEmpty) {
      context.read<EventBloc>().add(
        UpdateEventEvent(
          eventId: widget.eventId,
          name: controller.text,
          eventStart: DateFormat(
            "yyyy-MM-dd",
          ).format(DateFormat("dd/MM/yyyy").parse(eventStartController.text)),
          eventEnd: DateFormat(
            "yyyy-MM-dd",
          ).format(DateFormat("dd/MM/yyyy").parse(eventEndController.text)),
          description: descriptionController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AppShell(
      currentIndex: 0,
      child: Layout(
        onRefresh: () {
          context.read<user_bloc.LoadedUsersBloc>().add(
            user_event.InitialEvent(
              widget.eventId,
              user_event.LoadType.eventParticipants,
              searchQuery: '',
            ),
          );
          context.read<EventBloc>().add(GetEventEvent(eventId: widget.eventId));

          controller.text = widget.eventName;
          return Future.value();
        },
        title: widget.eventName,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ContentCard(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      intl.addMembers,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: AppThemes.borderColor,
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      text: intl.eventAddMemberHint,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                      children: [
                        TextSpan(
                          text: ' ${intl.groupAddMemberQr}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppThemes.primary3Color,
                          ),
                        ),
                        TextSpan(
                          text: ' ${intl.or}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        TextSpan(
                          text: ' ${intl.eventAddMembers}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppThemes.primary3Color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomButton(
                        text: intl.qrCode,
                        onPressed: () {},
                        size: ButtonSize.medium,
                      ),
                      CustomButton(
                        text: intl.groupMember,
                        onPressed: () {
                          context.pushNamed(
                            AppRouteNames.chooseMember,
                            extra: {
                              'id': widget.groupId,
                              'type': user_event.LoadType.groupMembers,
                              'initialSelected': selectedMembers,
                              'onChanged': (List<UserModel> users) {
                                setState(() {
                                  selectedMembers = users;
                                  selectedUserIdsToAdd = users
                                      .map((u) => u.id ?? '')
                                      .where((id) => id.isNotEmpty)
                                      .toList();
                                });
                              },
                              'isMultiSelect': true,
                            },
                          );
                        },
                        size: ButtonSize.medium,
                        type: ButtonType.secondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  UserGrid(
                    users: selectedMembers,
                    onTap: (user) {
                      setState(() {
                        selectedMembers.remove(user);
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  if (selectedMembers.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomButton(
                          text: intl.cancel,
                          onPressed: () {
                            setState(() {
                              selectedMembers = [];
                              selectedUserIdsToAdd = [];
                            });
                          },
                          size: ButtonSize.medium,
                        ),
                        CustomButton(
                          text: intl.save,
                          onPressed: () {
                            context.read<EventBloc>().add(
                              AddMembersToEvent(
                                eventId: widget.eventId,
                                memberIds: selectedUserIdsToAdd,
                              ),
                            );
                          },
                          size: ButtonSize.medium,
                          type: ButtonType.secondary,
                        ),
                      ],
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            BlocBuilder<EventBloc, EventState>(
              builder: (context, state) {
                if (state is! EventLoadedState) {
                  return const Center(
                    child: ColoredBox(
                      color: Colors.transparent,
                      child: SpinKitFadingCircle(
                        color: AppThemes.primary3Color,
                      ),
                    ),
                  );
                }

                controller.text = state.event.name ?? '';
                descriptionController.text = state.event.description ?? '';
                if (state.event.eventStart != null) {
                  eventStartController.text = DateFormat(
                    "dd/MM/yyyy",
                  ).format(state.event.eventStart!);
                }
                if (state.event.eventEnd != null) {
                  eventEndController.text = DateFormat(
                    "dd/MM/yyyy",
                  ).format(state.event.eventEnd!);
                }

                return ContentCard(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          intl.eventSettings,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppThemes.borderColor,
                      ),
                      const SizedBox(height: 16),
                      CustomTextInputWidget(
                        size: TextInputSize.large,
                        controller: controller,
                        keyboardType: TextInputType.text,
                        isReadOnly: false,
                        hintText: intl.eventNameHint,
                        label: intl.eventNameLabel,
                        isRequired: true,
                      ),
                      const SizedBox(height: 8),
                      CustomTextInputWidget(
                        size: TextInputSize.large,
                        controller: descriptionController,
                        keyboardType: TextInputType.text,
                        isReadOnly: false,
                        hintText: intl.eventDescriptionHint,
                        label: intl.eventDescriptionLabel,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 320,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            DateInputField(
                              label: intl.eventStartDateLabel,
                              hintText: '13/05/2025',
                              controller: eventStartController,
                              size: TextInputSize.medium,
                              isRequired: true,
                              validator: (value) {
                                return CustomValidator().validateDateForEvent(
                                  intl,
                                  eventStartController,
                                  eventEndController,
                                );
                              },
                            ),

                            const SizedBox(width: 8),
                            DateInputField(
                              label: intl.eventEndDateLabel,
                              hintText: '13/05/2025',
                              controller: eventEndController,
                              size: TextInputSize.medium,
                              isRequired: true,
                              validator: (value) {
                                return CustomValidator().validateDateForEvent(
                                  intl,
                                  eventStartController,
                                  eventEndController,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              intl.members,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    fontSize: 12,
                                    letterSpacing: 0,
                                    height: 16 / 12,
                                    color: Colors.grey,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          BlocBuilder<
                            user_bloc.LoadedUsersBloc,
                            user_state.LoadedUsersState
                          >(
                            buildWhen: (p, c) =>
                                p.users != c.users ||
                                p.isLoading != c.isLoading,
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
                              } else if (state.users.isEmpty) {
                                return noUserWidget(intl, theme);
                              }

                              members = state.users
                                  .map((e) => e.id)
                                  .whereType<String>()
                                  .toList();

                              memberModels = state.users;

                              return UserGrid(
                                users: state.users,
                                onTap: null,
                                isSelectable: false,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            CustomButton(
              text: intl.save,
              onPressed: () {
                updateEvent();
              },
              customColor: AppThemes.successColor,
            ),

            const SizedBox(height: 16),

            CustomButton(
              text: intl.leave,
              onPressed: () {
                // Thoát khỏi sự kiện
              },
              type: ButtonType.secondary,
              customColor: AppThemes.errorColor,
            ),

            const SizedBox(height: 16),
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
              Icon(Icons.no_accounts, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(intl.noSearchResults, style: theme.textTheme.titleSmall),
            ],
          ),
        );
      },
    );
  }
}
