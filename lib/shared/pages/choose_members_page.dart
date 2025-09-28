import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/presentation/bloc/user_bloc.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart';
import 'package:Dividex/features/user/presentation/bloc/user_state.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/info_card.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChooseMembersPage extends StatefulWidget {
  final String? id;
  final LoadType type;
  final ValueChanged<List<UserModel>> onSelectedMembersChanged;
  final List<UserModel>? initialSelectedMembers;
  final bool isMultiSelect;
  const ChooseMembersPage({
    super.key,
    required this.type,
    required this.onSelectedMembersChanged,
    required this.initialSelectedMembers,
    required this.id,
    required this.isMultiSelect,
  });

  @override
  State<ChooseMembersPage> createState() => _ChooseMembersPageState();
}

class _ChooseMembersPageState extends State<ChooseMembersPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<UserModel> _selectedUsers = []; // <-- lưu user đã chọn

  @override
  void initState() { 
    super.initState();
    _selectedUsers.addAll(widget.initialSelectedMembers ?? []);
    context.read<LoadedUsersBloc>().add(InitialEvent(widget.id, widget.type));
  }

  void _toggleUser(UserModel user) {
    if (!widget.isMultiSelect) {
      // Nếu không phải multi-select, clear danh sách trước khi thêm
      _selectedUsers.clear();
    }
    setState(() {
      if (_selectedUsers.any((u) => u.id == user.id)) {
        // Nếu đã chọn thì remove
        _selectedUsers.removeWhere((u) => u.id == user.id);
      } else {
        // Nếu chưa có thì add
        _selectedUsers.add(user);
      }
    });

    // Gửi danh sách mới ra ngoài
    widget.onSelectedMembersChanged(_selectedUsers);
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AppShell(
      currentIndex: 0,
      child: SimpleLayout(
        title: intl.addMembers,
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
                  context.read<LoadedUsersBloc>().add(
                    InitialEvent(
                      widget.id,
                      widget.type,
                      searchQuery: _searchController.text,
                    ),
                  );
                },
                icon: Icon(Icons.search),
              ),
            ),

            // results
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

                final hasMore = state.users.length < state.totalItems;
                final String myId = HiveService.getUser().id ?? '';
                final usersWithoutMyself = state.users
                    .where((user) => user.id != myId)
                    .toList();

                return listResults(
                  intl,
                  hasMore,
                  state.totalItems,
                  usersWithoutMyself,
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
              Icon(Icons.no_accounts, size: 64, color: Colors.grey[400]),
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
    int totalUsers,
    List<UserModel>? users,
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
              children: totalUsers > 0
                  ? [
                      TextSpan(
                        text: totalUsers > 99 ? ' 99+' : ' $totalUsers',
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
          itemCount: users?.length != null
              ? (users!.length + (hasMore ? 1 : 0))
              : 0,
          itemBuilder: (context, index) {
            if (index == users!.length) {
              context.read<LoadedUsersBloc>().add(
                LoadMoreUsersEvent(
                  widget.id,
                  widget.type,
                  searchQuery: _searchController.text.isEmpty
                      ? null
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

            final user = users[index];
            final isSelected = _selectedUsers.any((u) => u.id == user.id);

            return InfoCard(
              title: user.fullName ?? '',
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey,
                backgroundImage: (user.avatar != null && user.avatar!.publicUrl.isNotEmpty)
                    ? NetworkImage(user.avatar!.publicUrl)
                    : NetworkImage(
                            'https://ui-avatars.com/api/?name=${Uri.encodeComponent(user.fullName ?? 'User')}&background=random&color=fff&size=128',
                          ),
              ),
              onTap: () {
                // Navigate to friend's profile
                print('Navigate to ${user.fullName} profile');
              },
              trailing: CustomButton(
                size: ButtonSize.small,
                text: isSelected ? intl.cancel : intl.add,
                customColor: isSelected ? AppThemes.errorColor : AppThemes.primary3Color,
                onPressed: () => _toggleUser(user),
              ),
            );
          },
        ),
      ],
    );
  }
}
