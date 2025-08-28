import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/presentation/bloc/user_bloc.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart';
import 'package:Dividex/features/user/presentation/bloc/user_state.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_bloc/flutter_bloc.dart';

enum MemberSelectorEnum { group, event, expense }

class MemberSelector extends StatefulWidget {
  final MemberSelectorEnum selectorType;
  final String id;
  final List<UserModel> initialSelectedMembers;
  final ValueChanged<List<UserModel>> onSelectedMembersChanged;

  const MemberSelector({
    super.key,
    required this.id,
    required this.selectorType,
    required this.onSelectedMembersChanged,
    required this.initialSelectedMembers,
  });

  @override
  State<MemberSelector> createState() => _MemberSelectorState();
}

class _MemberSelectorState extends State<MemberSelector> {
  final List<UserModel> _selectedMembers = [];
  List<UserModel> members = [];
  int page = 1;

  void _toggleMember(UserModel member) {
    setState(() {
      if (_selectedMembers.contains(member)) {
        _selectedMembers.remove(member);
      } else {
        _selectedMembers.add(member);
      }
      widget.onSelectedMembersChanged(_selectedMembers);
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedMembers.addAll(widget.initialSelectedMembers);
  }

  void callEvent() {
    if (widget.selectorType == MemberSelectorEnum.event) {
      context.read<LoadedUsersBloc>().add(
        RefreshUsersEvent(widget.id, LoadUsersAction.getGroupMembers),
      );
    } else if (widget.selectorType == MemberSelectorEnum.expense) {
      context.read<LoadedUsersBloc>().add(
        RefreshUsersEvent(widget.id, LoadUsersAction.getEventParticipants),
      );
    } else {
      context.read<LoadedUsersBloc>().add(
        RefreshUsersEvent(HiveService.getUser().id, LoadUsersAction.getFriends),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(intl.eventMembers, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        // Hiển thị các member đã chọn
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _selectedMembers.map((m) {
            return GestureDetector(
              onTap: () => _toggleMember(m),
              child: Chip(
                avatar: CircleAvatar(
                  backgroundImage: NetworkImage(m.avatar ?? ''),
                  child: const Icon(Icons.person),
                ),
                label: Text(m.fullName ?? ''),
                deleteIcon: const Icon(Icons.close),
                onDeleted: () => _toggleMember(m),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        // Hiển thị list member để chọn
        BlocBuilder<LoadedUsersBloc, LoadedUsersState>(
          buildWhen: (p, c) => p.users != c.users || p.isLoading != c.isLoading,
          builder: (context, state) {
            if (state.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state.users.isEmpty) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      callEvent();
                    },
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        child: Center(child: Text('Empty')),
                      ),
                    ),
                  );
                },
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                callEvent();
              },
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.users.length + (state.page < state.totalPage ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.users.length) {
                    if (widget.selectorType == MemberSelectorEnum.event) {
                      context.read<LoadedUsersBloc>().add(
                        LoadMoreUsersEvent(widget.id, LoadUsersAction.getGroupMembers),
                      );
                    } else if (widget.selectorType ==
                        MemberSelectorEnum.expense) {
                      context.read<LoadedUsersBloc>().add(
                        LoadMoreUsersEvent(
                          widget.id,
                          LoadUsersAction.getEventParticipants,
                        ),
                      );
                    } else {
                      context.read<LoadedUsersBloc>().add(
                        LoadMoreUsersEvent(
                          HiveService.getUser().id,
                          LoadUsersAction.getFriends,
                        ),
                      );
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final member = state.users[index];
                  final isSelected = _selectedMembers.contains(member);

                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(member.avatar ?? ''),
                        child: const Icon(Icons.person),
                      ),
                      title: Text(member.fullName ?? ''),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_circle,
                              color: AppThemes.primary3Color,
                            )
                          : const Icon(Icons.circle_outlined),
                      onTap: () => _toggleMember(member),
                    ),
                  );
                
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
