import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/notifications/data/model/notification_model.dart';
import 'package:Dividex/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:Dividex/features/notifications/presentation/bloc/notification_event.dart';
import 'package:Dividex/features/notifications/presentation/bloc/notification_state.dart';
import 'package:Dividex/shared/utils/noti_parser.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/content_card.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class NotiPage extends StatefulWidget {
  const NotiPage({super.key});

  @override
  State<NotiPage> createState() => _NotiPageState();
}

class _NotiPageState extends State<NotiPage> {
  @override
  void initState() {
    super.initState();
    context.read<LoadedNotiBloc>().add(InitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return AppShell(
      currentIndex: 1,
      child: SimpleLayout(
        title: intl.notifications,
        child: Column(
          children: [
            // results
            BlocBuilder<LoadedNotiBloc, LoadedNotiState>(
              buildWhen: (p, c) =>
                  p.notis != c.notis || p.isLoading != c.isLoading,
              builder: (context, searchState) {
                if (searchState.isLoading) {
                  return const Center(
                    child: ColoredBox(
                      color: Colors.transparent,
                      child: SpinKitFadingCircle(
                        color: AppThemes.primary3Color,
                      ),
                    ),
                  );
                } else if (searchState.notis.isEmpty) {
                  return notFoundWidget(intl, context);
                }

                final hasMore = searchState.page < searchState.totalPage;

                return notiCardList(hasMore, context, searchState.notis, searchState.page);
              },
            ),
          ],
        ),
      ),
    );
  }

  Center notFoundWidget(AppLocalizations intl, BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Icon(
            Icons.notification_important_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            intl.noSearchResults,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }

  Column notiCardList(
    bool hasMore,
    BuildContext context,
    List<NotificationModel>? notis,
    int page,
  ) {
    return Column(
      children: [
        const SizedBox(height: 16),
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: notis?.length != null
              ? (notis!.length + (hasMore ? 1 : 0))
              : 0,
          itemBuilder: (context, index) {
            if (index == notis!.length) {
              context.read<LoadedNotiBloc>().add(
                LoadMoreNotiEvent(page + 1, 20),
              );
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: SpinKitFadingCircle(color: const Color(0xFF08AE02)),
                ),
              );
            }

            return ContentCard(
              onTap: () => {
                notis[index].type.goToRelatedPage(notis[index].relatedUid, context, notis[index].fromUser)
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey,
                    backgroundImage:
                        (notis[index].fromUser.avatar != null &&
                            notis[index].fromUser.avatar!.publicUrl.isNotEmpty)
                        ? NetworkImage(notis[index].fromUser.avatar!.publicUrl)
                        : NetworkImage(
                            'https://ui-avatars.com/api/?name=${Uri.encodeComponent(notis[index].fromUser.fullName ?? 'User')}&background=random&color=fff&size=128',
                          ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          NotificationParser(AppLocalizations.of(context)!)
                              .parse(notis[index].content),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat(
                            "yyyy-MM-dd HH:mm",
                          ).format(notis[index].createdAt),
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
