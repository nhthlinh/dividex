import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/features/group/presentation/bloc/group_bloc.dart';
import 'package:Dividex/features/group/presentation/bloc/group_event.dart';
import 'package:Dividex/features/group/presentation/bloc/group_state.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupWidget extends StatefulWidget {
  const GroupWidget({super.key});

  @override
  State<GroupWidget> createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget> {
  final List<GroupModel> _groupList = [];

  final _textEditingController = TextEditingController();

  List<int> _selectedMemberIndices = [];

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<String>.empty();
              }
              // Giả lập tìm kiếm nhóm
              return _groupList
                  .where(
                    (group) => group.name!.toLowerCase().contains(
                      textEditingValue.text.toLowerCase(),
                    ),
                  )
                  .map<String>((group) => group.name as String);
            },
            fieldViewBuilder:
                (
                  BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onEditingComplete,
                ) {
                  return CustomTextInput(
                    label: intl.searchTab,
                    controller: textEditingController,
                    focusNode: focusNode,
                    onEditingComplete: onEditingComplete,
                  );
                },
            onSelected: (String selection) {
              debugPrint('Bạn đã chọn $selection');
              // Xử lý khi chọn một item
            },
          ),
        ),
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
                        RefreshGroupsEvent(HiveService.getUser().id),
                      );
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

            _groupList.clear();
            _groupList.addAll(state.groups);

           // chỉ khởi tạo khi chưa có dữ liệu (tránh reset mỗi lần build)
if (_selectedMemberIndices.length != _groupList.length) {
  _selectedMemberIndices = List.filled(_groupList.length, 0);
}

            return Expanded(
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _groupList.length,
                itemBuilder: (context, index) {
                  final group = _groupList[index];
                  final members = group.members ?? [];

                  final currentMember = members[_selectedMemberIndices[index]];

                  if (_selectedMemberIndices[index] >= members.length) {
                    _selectedMemberIndices[index] = 0;
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(group.avatarUrl ?? ''),
                                  backgroundColor: Colors.grey,
                                  child: Icon(Icons.group, color: Colors.white),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  group.name ?? '',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Hiển thị các thành viên trong nhóm
                            /// Avatars cuộn ngang
                            SizedBox(
                              height: 60,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: members.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 8),
                                itemBuilder: (context, idx) {
                                  final member = members[idx];
                                  final isSelected =
                                      idx == _selectedMemberIndices[index];

                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedMemberIndices[index] = idx;
                                      });
                                    },
                                    child: CircleAvatar(
                                      radius: isSelected ? 35 : 22,
                                      backgroundColor: isSelected
                                          ? Colors.blueAccent
                                          : Colors.grey,
                                      backgroundImage: member.user?.avatar !=
                                                  null &&
                                              member.user!.avatar!.isNotEmpty
                                          ? NetworkImage(member.user!.avatar!)
                                          : null,
                                      child: member.user?.avatar == null
                                          ? const Icon(Icons.person,
                                              color: Colors.white)
                                          : null,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),

                            /// Debt info
                            Row(
                              children: [
                                Text(
                                  '${(currentMember.hasDebt ?? false) ? intl.ownYou : intl.youOwn} ${currentMember.amount} đ',
                                  style: TextStyle(
                                    color: (currentMember.hasDebt ?? false)
                                        ? Colors.red
                                        : Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            /// Button action
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  // xử lý theo member hiện tại
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      (currentMember.hasDebt ?? false)
                                          ? Colors.red[700]
                                          : Colors.green[700],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: Text(
                                  (currentMember.hasDebt ?? false)
                                      ? intl.remind
                                      : intl.pay,
                                  style:
                                      const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          
                            
                            
                          ],
                        ),
                      ),
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
