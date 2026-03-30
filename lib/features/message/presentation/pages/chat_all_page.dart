import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/features/group/presentation/bloc/group_bloc.dart';
import 'package:Dividex/features/group/presentation/bloc/group_state.dart';
import 'package:Dividex/features/group/presentation/bloc/group_event.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/content_card.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class ChatAllPage extends StatefulWidget {
  const ChatAllPage({super.key});

  @override
  State<ChatAllPage> createState() => _ChatAllPageState();
}

class _ChatAllPageState extends State<ChatAllPage> {
  final List<GroupModel> _groupList = [];

  final _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<LoadedGroupsBloc>().add(InitialEvent('', false));
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AppShell(
      currentIndex: 2,
      child: SimpleLayout(
        onRefresh: () {
          context.read<LoadedGroupsBloc>().add(RefreshGroupsEvent('', false));
          return Future.value();
        },
        title: intl.group,
        child: Column(
          children: [
            CustomTextInputWidget(
              size: TextInputSize.large,
              isReadOnly: false,
              keyboardType: TextInputType.text,
              label: intl.searchTab,
              controller: _textEditingController,
              suffixIcon: IconButton(
                onPressed: () {
                  context.read<LoadedGroupsBloc>().add(
                    InitialEvent(_textEditingController.text, true),
                  );
                },
                icon: Icon(Icons.search),
              ),
            ),

            BlocBuilder<LoadedGroupsBloc, LoadedGroupsState>(
              buildWhen: (p, c) =>
                  p.groups != c.groups || p.isLoading != c.isLoading,
              builder: (context, state) {
                if (state.isLoading) {
                  return Center(
                    child: SpinKitFadingCircle(color: AppThemes.primary3Color),
                  );
                }

                if (state.groups.isEmpty) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<LoadedGroupsBloc>().add(
                            RefreshGroupsEvent('', true),
                          );
                        },
                        child: noGroupWidget(intl, theme),
                      );
                    },
                  );
                }

                _groupList.clear();
                _groupList.addAll(state.groups);

                bool hasMore = state.page < state.totalPage;

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _groupList.length + (hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _groupList.length) {
                      // Load more indicator
                      if (hasMore) {
                        context.read<LoadedGroupsBloc>().add(
                          LoadMoreGroupsEvent(
                            _textEditingController.text,
                            true,
                          ),
                        );
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: SpinKitFadingCircle(
                                color: AppThemes.primary3Color,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    }

                    final group = _groupList[index];

                    if (index == 0) {
                      return Column(
                        children: [
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(
                                text: intl.group,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      fontSize: 12,
                                      letterSpacing: 0,
                                      height: 16 / 12,
                                      color: Colors.grey,
                                    ),
                                children: state.totalItems > 0
                                    ? [
                                        TextSpan(
                                          text: state.totalItems > 99
                                              ? ' 99+'
                                              : ' ${state.totalItems}',
                                          style: TextStyle(
                                            color: AppThemes.primary3Color,
                                          ),
                                        ),
                                      ]
                                    : [],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          groupWidget(context, group, intl),
                        ],
                      );
                    }

                    return groupWidget(context, group, intl);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  ContentCard groupWidget(
    BuildContext context,
    GroupModel group,
    AppLocalizations intl,
  ) {
    return ContentCard(
      onTap: () {
        context.pushNamed(
          AppRouteNames.chatInGroup,
          pathParameters: {"groupId": group.id ?? ''},
          extra: {"groupId": group.id ?? '', "groupName": group.name ?? ''},
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey,
            backgroundImage:
                (group.avatarUrl != null &&
                    group.avatarUrl!.publicUrl.isNotEmpty)
                ? NetworkImage(group.avatarUrl!.publicUrl)
                : NetworkImage(
                    'https://ui-avatars.com/api/?name=${Uri.encodeComponent(group.name ?? 'Group')}&background=random&color=fff&size=128',
                  ),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                group.name ?? '',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ],
      ),
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
