import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/features/group/presentation/bloc/group_bloc.dart';
import 'package:Dividex/features/group/presentation/bloc/group_event.dart'
    as group_event;
import 'package:Dividex/features/group/presentation/bloc/group_state.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart'
    as user_event;
import 'package:Dividex/shared/services/local/hive_service.dart';
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
      print('Event Name: ${eventNameController.text}');
      print('Event Description: ${eventDescriptionController.text}');
      print('Event Start Date: ${eventStartDateController.text}');
      print('Event End Date: ${eventEndDateController.text}');
      print('Selected Group: ${selectedGroup.value?.name ?? ''}');
      print('Selected Members: $selectedMembers');

      // final DioClient dio = DioClient(Dio(
      //   BaseOptions(
      //     baseUrl: dotenv.env['BASE_URL'] ?? '', // Replace with your API base URL
      //     connectTimeout: const Duration(seconds: 10),
      //     receiveTimeout: const Duration(seconds: 10),
      //     headers: {
      //       'Authorization':
      //           'Bearer ${HiveService.getToken()?.accessToken?.trim()}',
      //       'Accept-Language': HiveService.getSettings().localeCode,
      //     },
      //   ),
      // ));

      // try {
      //   await dio.post('/events', data: {
      //     'name': eventNameController.text,
      //     'list_user_uid': selectedMembers.map((e) => e.id).toList(),
      //     'group_id': selectedGroupId,
      //     'description': eventDescriptionController.text,
      //     'event_start': DateFormat("yyyy-MM-dd").format(DateFormat("dd/MM/yyyy").parse(eventStartDateController.text)),
      //     'event_end': DateFormat("yyyy-MM-dd").format(DateFormat("dd/MM/yyyy").parse(eventEndDateController.text)),
      //   });
      // } catch (e) {
      //   rethrow;
      // }
      // final intl = AppLocalizations.of(context)!;

      // showCustomToast(intl.success, type: ToastType.success);

      Navigator.of(context).pop(); // Go back after submission
    }
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
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
        title: intl.addEvent,
        child: BlocProvider(
          create: (context) =>
              LoadedGroupsBloc()
                ..add(group_event.InitialEvent(HiveService.getUser().id ?? '')),
          child: eventForm(intl, theme),
        ),
      ),
    );
  }

  CustomFormWrapper eventForm(AppLocalizations intl, ThemeData theme) {
    return CustomFormWrapper(
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

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextInputWidget(
                isRequired: true,
                size: TextInputSize.medium,
                keyboardType: TextInputType.datetime,
                label: intl.eventStartDateLabel,
                hintText: '13/05/2025',
                controller: eventStartDateController,
                isReadOnly: true,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(
                    navigatorKey.currentContext!,
                    eventStartDateController,
                  ),
                ), // Mở DatePicker khi tap
                validator: (value) {
                  return CustomValidator().validateDateForEvent(
                    intl,
                    eventStartDateController,
                    eventEndDateController,
                  );
                },
              ),

              const SizedBox(width: 8),
              CustomTextInputWidget(
                isRequired: true,
                size: TextInputSize.medium,
                keyboardType: TextInputType.datetime,
                label: intl.eventEndDateLabel,
                hintText: '13/05/2025',
                controller: eventEndDateController,
                isReadOnly: true,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(
                    navigatorKey.currentContext!,
                    eventEndDateController,
                  ),
                ), // Mở DatePicker khi tap
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
                  },
                );
              },
            ),
            const SizedBox(height: 8),
            UserGrid(users: selectedMembers),
          ],

          const SizedBox(height: 30),
          CustomButton(text: intl.add, onPressed: isValid ? submitEvent : null),
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
                    Image.network(
                      b.avatarUrl!,
                      width: 50,
                      height: 50,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.event),
                    )
                  else
                    const Icon(Icons.event),
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
