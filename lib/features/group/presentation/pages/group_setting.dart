import 'dart:async';

import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/group/presentation/bloc/group_bloc.dart'
    as group_bloc;
import 'package:Dividex/features/group/presentation/bloc/group_event.dart'
    as group_event;
import 'package:Dividex/features/image/data/models/image_model.dart';
import 'package:Dividex/features/image/presentation/bloc/image_bloc.dart';
import 'package:Dividex/features/image/presentation/bloc/image_state.dart';
import 'package:Dividex/features/image/presentation/widgets/image_picker_widget.dart';
import 'package:Dividex/features/image/presentation/widgets/image_update_delete_widget.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/presentation/bloc/user_bloc.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart';
import 'package:Dividex/features/user/presentation/bloc/user_state.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/content_card.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/layout.dart';
import 'package:Dividex/shared/widgets/show_dialog_widget.dart';
import 'package:Dividex/shared/widgets/user_grid_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class GroupSettingPage extends StatefulWidget {
  final String groupId;
  final String groupLeaderId;
  final String groupName;
  final ImageModel? groupAvatarUrl;
  const GroupSettingPage({
    super.key,
    required this.groupId,
    required this.groupLeaderId,
    required this.groupName,
    required this.groupAvatarUrl,
  });

  @override
  State<GroupSettingPage> createState() => _GroupSettingPageState();
}

class _GroupSettingPageState extends State<GroupSettingPage> {
  final TextEditingController controller = TextEditingController();
  // Chọn thêm
  List<UserModel> selectedMembers = [];
  List<String> selectedUserIdsToAdd = [];

  // Gốc
  List<String> members = [];
  List<UserModel> memberModels = [];

  // Xóa
  List<String> selectedUserIdsToDelete = [];

  List<ImageModel> deletedImages = [];
  List<Uint8List> updatedImages = [];

  UserModel? leader;

  @override
  void initState() {
    super.initState();
    context.read<LoadedUsersBloc>().add(
      InitialEvent(widget.groupId, LoadType.groupMembers, searchQuery: ''),
    );

    controller.text = widget.groupName;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void sanitizeLists() {
    // Xóa những id nằm trong cả Add và Delete
    selectedUserIdsToAdd.removeWhere(
      (id) => selectedUserIdsToDelete.contains(id),
    );
    selectedUserIdsToDelete.removeWhere(
      (id) => selectedUserIdsToAdd.contains(id),
    );

    // Không cho add lại user đã có sẵn
    selectedUserIdsToAdd.removeWhere((id) => members.contains(id));

    // Không cho delete user không tồn tại
    selectedUserIdsToDelete.removeWhere((id) => !members.contains(id));
  }

  Future<bool> confirmDeleteUser(String userId) async {
    final user = memberModels.firstWhere(
      (u) => u.id == userId,
      orElse: () => UserModel(id: userId, fullName: "Người dùng"),
    );

    final intl = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final completer = Completer<bool>();

    showCustomDialog(
      context: context,
      content: Column(
        children: [
          RichText(
            text: TextSpan(
              text: intl.delete,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
              children: [
                TextSpan(
                  text: ' ${user.fullName}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppThemes.primary3Color,
                  ),
                ),
                TextSpan(
                  text: ' ${intl.from}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                TextSpan(
                  text: ' ${widget.groupName}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppThemes.primary3Color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: AppThemes.borderColor),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              text: intl.deleteConfirm1,
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
              children: [
                TextSpan(
                  text: intl.deleteConfirm2,
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
                text: intl.cancel,
                onPressed: () {
                  context.pop();
                  completer.complete(false);
                },
                size: ButtonSize.medium,
                type: ButtonType.secondary,
                customColor: AppThemes.errorColor,
              ),
              CustomButton(
                text: intl.delete,
                onPressed: () {
                  context.pop();
                  completer.complete(true);
                },
                size: ButtonSize.medium,
                customColor: AppThemes.errorColor,
              ),
            ],
          ),
        ],
      ),
    );
    return completer.future;
  }

  Future<void> updateGroup() async {
    if (controller.text.isNotEmpty) {
      sanitizeLists();

      print(selectedUserIdsToAdd.map((e) => e).toList());
      print(selectedUserIdsToDelete.map((e) => e).toList());
      print(members.map((e) => e).toList());

      // Xác nhận xóa từng user
      List<String> confirmedDeletes = [];
      for (final id in selectedUserIdsToDelete) {
        bool confirmed = await confirmDeleteUser(id);
        if (confirmed) {
          confirmedDeletes.add(id);
        }
      }

      context.read<group_bloc.GroupBloc>().add(
        group_event.UpdateGroupEvent(
          groupId: widget.groupId,
          name: controller.text,
          memberIdsAdd: selectedUserIdsToAdd,
          memberIdsRemove: confirmedDeletes,
          avatar: updatedImages.isNotEmpty ? updatedImages[0] : null,
          deletedAvatarUid: deletedImages.isNotEmpty ? deletedImages[0].uid : null
        ),
      );

      if (leader != null && leader!.id != widget.groupLeaderId) {
        context.read<group_bloc.GroupBloc>().add(
          group_event.UpdateGroupLeaderEvent(
            groupId: widget.groupId,
            newLeaderId: leader!.id!,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AppShell(
      currentIndex: 0,
      child: Layout(
        title: widget.groupName,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                onTap: () {
                  context.pushNamed(
                  AppRouteNames.listExpenseDeleted,
                  pathParameters: {
                    'groupId': widget.groupId,
                  },
                  extra: {
                    'groupName': widget.groupName,
                    'groupAvatarUrl': widget.groupAvatarUrl?.publicUrl ?? '',
                  },
                );
                },
                child: Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          intl.deleteExpense,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontSize: 12,
                                letterSpacing: 0,
                                height: 16 / 12,
                                color: Colors.grey,
                              ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
              ),
            ),

            const SizedBox(height: 16),
                  

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
                      text: intl.groupAddMemberHint,
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
                          text: ' ${intl.groupAddMemberFriends}',
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
                        text: intl.friend,
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
                  const SizedBox(height: 16),
                  UserGrid(
                    users: selectedMembers,
                    onTap: (user) {
                      setState(() {
                        selectedMembers.remove(user);
                      });
                    },
                  ),

                  if (selectedMembers.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    CustomButton(
                      text: intl.save,
                      onPressed: () {
                        updateGroup();
                      },
                      customColor: AppThemes.successColor,
                    ),

                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            if (HiveService.getUser().id == widget.groupLeaderId) ...[
              ContentCard(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        intl.groupSettings,
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

                    // Column(
                    //   children: [
                    //     Align(
                    //       alignment: Alignment.centerLeft,
                    //       child: Text(
                    //         intl.addGroupImageLabel,
                    //         style: Theme.of(context).textTheme.titleSmall
                    //             ?.copyWith(
                    //               fontSize: 12,
                    //               letterSpacing: 0,
                    //               height: 16 / 12,
                    //               color: Colors.grey,
                    //             ),
                    //       ),
                    //     ),
                    //     CircleAvatar(
                    //       radius: 40,
                    //       backgroundImage: widget.groupAvatarUrl == ''
                    //           ? NetworkImage(
                    //               'https://ui-avatars.com/api/?name=${Uri.encodeComponent(widget.groupName)}&background=random&color=fff&size=128',
                    //             )
                    //           : NetworkImage(widget.groupAvatarUrl),
                    //     ),
                    //   ],
                    // ),
                    BlocProvider(
                      create: (context) => ImageBloc(),
                      child: BlocBuilder<ImageBloc, ImageState>(
                        builder: (context, state) {
                          return ImageUpdateDeleteWidget(
                            label: intl.addGroupImageLabel,
                            nameForExampleImage: widget.groupName,
                            isAvatar: true,
                            type: PickerType.avatar,
                            images: widget.groupAvatarUrl != null
                                ? [widget.groupAvatarUrl!]
                                : [],
                            onFilesPicked: (List<Uint8List> files) {
                              updatedImages = [files[0]];
                            },
                            onDelete: (image) {
                              deletedImages = [image];
                            },
                          );
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    CustomTextInputWidget(
                      size: TextInputSize.large,
                      controller: controller,
                      keyboardType: TextInputType.text,
                      isReadOnly: false,
                      hintText: intl.groupNameHint,
                      label: intl.groupNameLabel,
                      isRequired: true,
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
                        BlocBuilder<LoadedUsersBloc, LoadedUsersState>(
                          buildWhen: (p, c) =>
                              p.users != c.users || p.isLoading != c.isLoading,
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
                              onTap: (user) {
                                setState(() {
                                  if (selectedUserIdsToDelete.contains(
                                    user.id,
                                  )) {
                                    selectedUserIdsToDelete.remove(user.id);
                                  } else {
                                    if (user.id != null) {
                                      selectedUserIdsToDelete.add(user.id!);
                                    }
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              CustomButton(
                text: intl.groupChangeLeader,
                onPressed: () {
                  context.pushNamed(
                    AppRouteNames.chooseMember,
                    extra: {
                      'id': widget.groupId,
                      'type': LoadType.groupMembers,
                      'initialSelected': [
                        UserModel(
                          id: widget.groupLeaderId,
                          fullName: HiveService.getUser().fullName ?? '',
                          avatar: HiveService.getUser().avatarUrl,
                        ),
                      ],
                      'onChanged': (List<UserModel> users) {
                        setState(() {
                          leader = users.first;
                        });
                      },
                      'isMultiSelect': false,
                    },
                  );
                },
              ),

              const SizedBox(height: 10),

              if (leader != null)
                UserGrid(
                  users: leader != null ? [leader!] : [],
                  onTap: (user) {
                    setState(() {
                      leader = null;
                    });
                  },
                ),

              const SizedBox(height: 16),

              CustomButton(
                text: intl.save,
                onPressed: () {
                  updateGroup();
                },
                customColor: AppThemes.successColor,
              ),

              const SizedBox(height: 16),
            ],

            CustomButton(
              text: intl.leave,
              onPressed: () {
                context.read<group_bloc.GroupBloc>().add(
                  group_event.LeaveGroupEvent(widget.groupId),
                );
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
