import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/features/home/presentation/widgets/member_selector_widget.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/presentation/bloc/user_bloc.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart';
import 'package:Dividex/features/user/presentation/bloc/user_state.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/image_picker_widget.dart';
import 'package:Dividex/shared/widgets/wave_painter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddGroupPage extends StatefulWidget {
  final int groupId;

  const AddGroupPage({super.key, required this.groupId});

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

    if (widget.groupId != 0) {
      // Load group details for editing
      // For example:
      // groupNameController.text = existingGroup.name;
      // selectedMembers = existingGroup.members;
    }
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          intl.addGroup,
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
                child: groupForm(intl),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Form groupForm(AppLocalizations intl) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextInput(
            label: intl.groupNameLabel,
            hintText: intl.groupNameHint,
            controller: groupNameController,
            keyboardType: TextInputType.text,
            prefixIcon: const Icon(Icons.event, color: Colors.grey),
            validator: (value) {
              return CustomValidator().validateName(value, intl);
            },
          ),
          const SizedBox(height: 16),

          Text(
            intl.addGroupImageLabel,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 10),
          Center(
            child: ImagePickerField(
              isAvatar: true,
              onChanged: (paths) {
                setState(() {
                  groupImagePath = paths.first;
                });
              },
            ),
          ),

          const SizedBox(height: 16),
          BlocProvider(
            create: (context) => LoadedUsersBloc()..add(InitialEvent(HiveService.getUser().id ?? '', null)),
            child: BlocBuilder<LoadedUsersBloc, LoadedUsersState>(
              builder: (context, state) {
                return MemberSelector(
                  selectorType: MemberSelectorEnum.group,
                  id: HiveService.getUser().id ?? '',
                  initialSelectedMembers: selectedMembers,
                  onSelectedMembersChanged: (selected) {
                    setState(() {
                      selectedMembers = selected;
                    });
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 30),
          CustomButton(
            buttonText: intl.add,
            onPressed: () {
              submitGroup();
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
