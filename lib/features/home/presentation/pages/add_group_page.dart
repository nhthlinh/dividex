import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/features/home/presentation/widgets/member_selector_widget.dart';
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/text_button.dart';
import 'package:Dividex/shared/widgets/wave_painter.dart';
import 'package:flutter/material.dart';

class AddGroupPage extends StatefulWidget {
  final int groupId;

  const AddGroupPage({super.key, required this.groupId});

  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  final TextEditingController groupNameController = TextEditingController();

  // Members of event
  List<Member> selectedMembers = [
    Member(id: '1', name: 'John Doe', avatarUrl: 'https://example.com/john.jpg'),
  ];

  final List<String> _groups = ['Birthday', 'Wedding', 'Conference'];

  @override
  void initState() {
    super.initState();
    // TODO: Load existing group data if editing
    // Load Group
    // Load Members
  }

  @override
  void dispose() {
    groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(
      context,
    )!; // Lấy đối tượng AppLocalizations

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
          CustomTextButton(
            buttonText: intl.addGroupImageLabel,
            onPressed: () {
              // Handle image upload
            },
          ),
          
          const SizedBox(height: 16),
          MemberSelector(
            initialSelectedMembers: selectedMembers,
            onSelectedMembersChanged: (selected) {
              setState(() {
                selectedMembers = selected;
              });
            },
          ),

          const SizedBox(height: 30),
          CustomButton(
            buttonText: intl.add,
            onPressed: () {
              // Handle add expense
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
