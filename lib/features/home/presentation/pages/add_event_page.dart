import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/features/group/presentation/bloc/group_bloc.dart';
import 'package:Dividex/features/group/presentation/bloc/group_event.dart'
    as group_event;
import 'package:Dividex/features/group/presentation/bloc/group_state.dart';
import 'package:Dividex/features/home/presentation/widgets/member_selector_widget.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/presentation/bloc/user_bloc.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart'
    as user_event;
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_dropdown_widget.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/wave_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddEventPage extends StatefulWidget {
  final int eventId;

  const AddEventPage({super.key, required this.eventId});

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

  final ValueNotifier<String?> _selectedGroup = ValueNotifier('Birthday');

  // Members of event
  List<UserModel> selectedMembers = [];
  String? selectedGroupId;

  List<GroupModel> _groups = [];

  @override
  void initState() {
    super.initState();
    // TODO: Load existing event data if editing
    // Load Group
    // Load Members
    // Load Start Date
    // Load End Date
  }

  @override
  void dispose() {
    eventNameController.dispose();
    eventDescriptionController.dispose();
    eventStartDateController.dispose();
    eventEndDateController.dispose();
    super.dispose();
  }

  void submitEvent() {
    if (_formKey.currentState!.validate()) {
      // Submit the event data
      print('Event Name: ${eventNameController.text}');
      print('Event Description: ${eventDescriptionController.text}');
      print('Event Start Date: ${eventStartDateController.text}');
      print('Event End Date: ${eventEndDateController.text}');
      print('Selected Group: $selectedGroupId');
      print('Selected Members: $selectedMembers');
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          intl.addEvent,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: CustomPaint(painter: WavePainter()),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: BlocProvider(
                  create: (context) => LoadedGroupsBloc()
                    ..add(
                      group_event.InitialEvent(HiveService.getUser().id ?? ''),
                    ),
                  child: eventForm(intl),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Form eventForm(AppLocalizations intl) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextInput(
            label: intl.eventNameLabel,
            hintText: intl.eventNameHint,
            controller: eventNameController,
            keyboardType: TextInputType.text,
            prefixIcon: const Icon(Icons.event, color: Colors.grey),
            validator: (value) {
              return CustomValidator().validateName(value, intl);
            },
          ),
          const SizedBox(height: 16),
          CustomTextInput(
            label: intl.eventDescriptionLabel,
            hintText: intl.eventDescriptionHint,
            controller: eventDescriptionController,
            keyboardType: TextInputType.text,
            prefixIcon: const Icon(Icons.details_outlined, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          BlocBuilder<LoadedGroupsBloc, LoadedGroupsState>(
            buildWhen: (p, c) =>
                p.groups != c.groups || p.isLoading != c.isLoading,
            builder: (context, state) {
              if (state.isLoading) {
                return Center(child: CircularProgressIndicator());
              }

              if (state.groups.isEmpty) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<LoadedGroupsBloc>().add(
                          group_event.RefreshGroupsEvent(
                            HiveService.getUser().id ?? '',
                          ),
                        );
                      },
                      child: Center(child: Text('Empty')),
                    );
                  },
                );
              }
              _groups = state.groups;

              return ValueListenableBuilder<String?>(
                valueListenable: _selectedGroup,
                builder: (context, value, _) {
                  return CustomDropdownWidget<String?>(
                    label: intl.eventGroupLabel,
                    items: _groups.map((group) {
                      return DropdownMenuItem<String>(
                        value: group.id,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade300),
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                            ),
                          ),

                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundImage: NetworkImage(
                                  group.avatarUrl ?? '',
                                ),
                                child: const Icon(Icons.person),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                group.name ?? '',
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    value: value,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedGroup.value = newValue;
                        selectedGroupId = newValue;
                      });
                    },
                  );
                },
              );
            },
          ),

          const SizedBox(height: 16),
          CustomTextInput(
            label: intl.eventStartDateLabel,
            hintText: '13/05/2025',
            controller: eventStartDateController,
            isReadOnly: true, // Không cho phép gõ trực tiếp
            onTap: () => _selectDate(
              navigatorKey.currentContext!,
              eventStartDateController,
            ), // Mở DatePicker khi tap
            suffixIcon: const Icon(Icons.calendar_today), // Icon lịch
            inputFormatters: [DateInputFormatter()],
            validator: (value) {
              return CustomValidator().validateDateForEvent(
                intl,
                eventStartDateController,
                eventEndDateController,
              );
            },
          ),
          const SizedBox(height: 16),
          CustomTextInput(
            label: intl.eventEndDateLabel,
            hintText: '13/05/2025',
            controller: eventEndDateController,
            isReadOnly: true, // Không cho phép gõ trực tiếp
            onTap: () => _selectDate(
              navigatorKey.currentContext!,
              eventEndDateController,
            ), // Mở DatePicker khi tap
            suffixIcon: const Icon(Icons.calendar_today), // Icon lịch
            inputFormatters: [DateInputFormatter()],
            validator: (value) {
              return CustomValidator().validateDateForEvent(
                intl,
                eventStartDateController,
                eventEndDateController,
              );
            },
          ),
          const SizedBox(height: 16),

          if (selectedGroupId != null) ...[
            BlocProvider(
              create: (context) => LoadedUsersBloc()
                ..add(
                  user_event.InitialEvent(
                    selectedGroupId,
                    user_event.LoadUsersAction.getGroupMembers,
                  ),
                ),
              child: MemberSelector(
                selectorType: MemberSelectorEnum.event,
                id: selectedGroupId ?? '',
                initialSelectedMembers: selectedMembers,
                onSelectedMembersChanged: (selected) {
                  setState(() {
                    selectedMembers = selected;
                  });
                },
              ),
            ),
          ],
          const SizedBox(height: 30),
          CustomButton(
            buttonText: intl.add,
            onPressed: () {
              submitEvent();
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
