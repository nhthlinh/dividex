import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/event/event_bloc.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/event/event_event.dart';
import 'package:Dividex/features/event_expense/presentation/widgets/date_input_field_widget.dart';
import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/features/group/presentation/bloc/group_bloc.dart';
import 'package:Dividex/features/group/presentation/bloc/group_event.dart'
    as group_event;
import 'package:Dividex/features/group/presentation/bloc/group_state.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart'
    as user_event;
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_dropdown_widget.dart';
import 'package:Dividex/shared/widgets/custom_form_wrapper.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:Dividex/shared/widgets/text_button.dart';
import 'package:Dividex/shared/widgets/user_grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventDescriptionController =
      TextEditingController();
  final TextEditingController eventStartDateController =
      TextEditingController();
  final TextEditingController eventEndDateController = TextEditingController();

  final ValueNotifier<GroupModel?> selectedGroup = ValueNotifier(null);
  List<UserModel> selectedMembers = [];

  final clearFormTrigger = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    eventNameController.dispose();
    eventDescriptionController.dispose();
    eventStartDateController.dispose();
    eventEndDateController.dispose();
    super.dispose();
  }

  Future<void> submitEvent() async {
    if (_formKey.currentState!.validate()) {
      // Submit the event data
      // debugPrint('Event Name: ${eventNameController.text}');
      // debugPrint('Event Description: ${eventDescriptionController.text}');
      // debugPrint('Event Start Date: ${eventStartDateController.text}');
      // debugPrint('Event End Date: ${eventEndDateController.text}');
      // debugPrint('Selected Group: ${selectedGroup.value?.name ?? ''}');
      // debugPrint('Selected Members: $selectedMembers');

      context.read<EventBloc>().add(
        CreateEventEvent(
          name: eventNameController.text,
          groupId: selectedGroup.value?.id ?? '',
          eventStart: DateFormat("yyyy-MM-dd").format(
            DateFormat("dd/MM/yyyy").parse(eventStartDateController.text),
          ),
          eventEnd: DateFormat(
            "yyyy-MM-dd",
          ).format(DateFormat("dd/MM/yyyy").parse(eventEndDateController.text)),
          description: eventDescriptionController.text,
          memberIds: selectedMembers
              .map((e) => e.id)
              .whereType<String>()
              .toList(),
        ),
      );

      Navigator.of(context).pop(); // Go back after submission
    }
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(
      context,
    )!; // Lấy đối tượng AppLocalizations
    final theme = Theme.of(context);

    return AppShell(
      currentIndex: 0,
      child: SimpleLayout(
        onRefresh: () async {
          clearFormTrigger.value =
              !clearFormTrigger.value; // Trigger form reset
          return Future.value();
        },
        title: intl.addEvent,
        child: BlocProvider(
          create: (context) =>
              LoadedGroupsBloc()..add(group_event.InitialEvent('', false)),
          child: eventForm(intl, theme),
        ),
      ),
    );
  }

  CustomFormWrapper eventForm(AppLocalizations intl, ThemeData theme) {
    return CustomFormWrapper(
      clearTrigger: clearFormTrigger,
      formKey: _formKey,
      fields: [
        FormFieldConfig(controller: eventNameController, isRequired: true),
        FormFieldConfig(controller: eventStartDateController, isRequired: true),
        FormFieldConfig(controller: eventEndDateController, isRequired: true),
        FormFieldConfig(selectedValue: selectedGroup, isRequired: true),
      ],
      builder: (isValid) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            intl.addEventSubtitle,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 12,
              letterSpacing: 0,
              height: 16 / 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),

          CustomTextInputWidget(
            size: TextInputSize.large,
            keyboardType: TextInputType.text,
            isReadOnly: false,
            isRequired: true,
            label: intl.eventNameLabel,
            hintText: intl.eventNameHint,
            controller: eventNameController,
            validator: (value) {
              return CustomValidator().validateName(value, intl);
            },
          ),
          const SizedBox(height: 16),

          CustomTextInputWidget(
            size: TextInputSize.large,
            keyboardType: TextInputType.text,
            isReadOnly: false,
            label: intl.eventDescriptionLabel,
            hintText: intl.eventDescriptionHint,
            controller: eventDescriptionController,
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: 340,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DateInputField(
                  label: intl.eventStartDateLabel,
                  hintText: '13/05/2025',
                  controller: eventStartDateController,
                  size: TextInputSize.medium,
                  isRequired: true,
                  validator: (value) {
                    return CustomValidator().validateDateForEvent(
                      intl,
                      eventStartDateController,
                      eventEndDateController,
                    );
                  },
                ),

                const SizedBox(width: 8),
                DateInputField(
                  label: intl.eventEndDateLabel,
                  hintText: '13/05/2025',
                  controller: eventEndDateController,
                  size: TextInputSize.medium,
                  isRequired: true,
                  validator: (value) {
                    return CustomValidator().validateDateForEvent(
                      intl,
                      eventStartDateController,
                      eventEndDateController,
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          BlocBuilder<LoadedGroupsBloc, LoadedGroupsState>(
            buildWhen: (p, c) =>
                p.groups != c.groups || p.isLoading != c.isLoading,
            builder: (context, state) {
              if (state.isLoading) {
                return Center(
                  child: ColoredBox(
                    color: Colors.transparent,
                    child: SpinKitFadingCircle(color: AppThemes.primary3Color),
                  ),
                );
              }

              if (state.groups.isEmpty) {
                return noGroupWidget(intl, theme);
              }

              return groupDropdown(intl, state);
            },
          ),
          const SizedBox(height: 16),

          if (selectedGroup.value != null) ...[
            CustomTextButton(
              isRequired: true,
              isLeftAligned: true,
              description: intl.members,
              label: intl.addMembers,
              onPressed: () {
                context.pushNamed(
                  AppRouteNames.chooseMember,
                  extra: {
                    'id': selectedGroup.value?.id,
                    'type': user_event.LoadType.groupMembers,
                    'initialSelected': selectedMembers,
                    'onChanged': (List<UserModel> users) {
                      setState(() {
                        selectedMembers = users;
                      });
                    },
                    'isMultiSelect': true,
                  },
                );
              },
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
          ],

          const SizedBox(height: 30),
          CustomButton(
            text: intl.add,
            onPressed: (isValid && selectedMembers.isNotEmpty)
                ? () {
                    submitEvent();
                    // Clear the form after submission
                    clearFormTrigger.value =
                        !clearFormTrigger.value; // Trigger form reset
                  }
                : null,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  ValueListenableBuilder<GroupModel?> groupDropdown(
    AppLocalizations intl,
    LoadedGroupsState state,
  ) {
    return ValueListenableBuilder<GroupModel?>(
      valueListenable: selectedGroup,
      builder: (context, value, _) {
        return CustomDropdownWidget<GroupModel>(
          label: intl.eventGroupLabel,
          value: selectedGroup.value,
          options: state.groups,
          displayString: (b) => "${b.name}",
          buildOption: (b, selected) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Row(
                children: [
                  if (b.avatarUrl != null)
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(b.avatarUrl!.publicUrl),
                      backgroundColor: Colors.transparent,
                    )
                  else
                    SizedBox(width: 40, child: const Icon(Icons.group)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "${b.name}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: selected ? AppThemes.primary3Color : Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (selected)
                    const Icon(Icons.check, color: AppThemes.primary3Color),
                ],
              ),
            );
          },
          onChanged: (val) {
            selectedMembers = [];
            setState(() => selectedGroup.value = val);
          },
          isRequired: true,
        );
      },
    );
  }

  LayoutBuilder noGroupWidget(AppLocalizations intl, ThemeData theme) {
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
