import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/features/group/presentation/bloc/group_bloc.dart';
import 'package:Dividex/features/group/presentation/bloc/group_event.dart'
    as group_event;
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/presentation/bloc/user_bloc.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart';
import 'package:Dividex/features/user/presentation/bloc/user_state.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_form_wrapper.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/image_picker_widget.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:Dividex/shared/widgets/text_button.dart';
import 'package:Dividex/shared/widgets/user_grid_widget.dart';
import 'package:Dividex/shared/widgets/wave_painter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddGroupPage extends StatefulWidget {
  const AddGroupPage({super.key});

  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController groupNameController = TextEditingController();
  String? groupImagePath;
  Uint8List? imageBytes;
  List<UserModel> selectedMembers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    groupNameController.dispose();
    super.dispose();
  }

  void submitGroup() {
    if (_formKey.currentState!.validate()) {
      print('Group Name: ${groupNameController.text}');
      print('Group Image Path: $groupImagePath');
      print('Selected Members: $selectedMembers');

      context.read<LoadedGroupsBloc>().add(
        group_event.CreateGroupEvent(
          name: groupNameController.text,
          avatarPath: groupImagePath ?? '',
          memberIds: selectedMembers
              .map((e) => e.id)
              .whereType<String>()
              .toList(),
        ),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return AppShell(
      currentIndex: 0,
      child: SimpleLayout(title: intl.addGroup, child: groupForm(intl)),
    );
  }

  CustomFormWrapper groupForm(AppLocalizations intl) {
    return CustomFormWrapper(
      formKey: _formKey,
      fields: [
        FormFieldConfig(controller: groupNameController, isRequired: true),
      ],
      builder: (isValid) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Text(
              intl.addGroupSubtitle,
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
              isReadOnly: false,
              isRequired: true,
              label: intl.groupNameLabel,
              hintText: intl.groupNameHint,
              controller: groupNameController,
              keyboardType: TextInputType.text,
              validator: (value) {
                return CustomValidator().validateName(value, intl);
              },
            ),
            const SizedBox(height: 16),

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  intl.addGroupImageLabel,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 12,
                    letterSpacing: 0,
                    height: 16 / 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                ImagePickerWidget(
                  type: PickerType.avatar,
                  onFilesPicked: (imageBytesList) {
                    setState(() {
                      imageBytes = imageBytesList.isNotEmpty
                          ? imageBytesList.first
                          : null;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),
            CustomTextButton(
              isLeftAligned: true,
              description: intl.members,
              label: intl.addMembers,
              onPressed: () {
                context.pushNamed(
                  AppRouteNames.chooseMember,
                  extra: {
                    'id': HiveService.getUser().id,
                    'type': LoadType.friends,
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

            const SizedBox(height: 30),
            CustomButton(
              text: intl.add,
              onPressed: isValid ? submitGroup : null,
            ),
            const SizedBox(height: 30),
          ],
        );
      },
    );
  }
}
