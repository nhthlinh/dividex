import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/notifications/data/model/notification_model.dart';
import 'package:Dividex/features/notifications/domain/usecase.dart';
import 'package:Dividex/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:Dividex/features/notifications/presentation/bloc/notification_state.dart';
import 'package:Dividex/features/notifications/presentation/pages/noti_page.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockNotiUseCase extends Mock implements NotiUseCase {}

void main() {
  late NotiUseCase useCase;

  setUp(() async {
    await getIt.reset();
    useCase = _MockNotiUseCase();
    when(() => useCase.getNotifications(1, 20)).thenAnswer(
      (_) async => PagingModel<List<NotificationModel>>(
        data: <NotificationModel>[],
        page: 1,
        totalPage: 1,
        totalItems: 0,
      ),
    );
    getIt.registerSingletonAsync<NotiUseCase>(() async => useCase);
    await getIt.isReady<NotiUseCase>();
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('NotiPage shows loading indicator initially', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => LoadedNotiBloc()),
          ],
          child: const NotiPage(),
        ),
      ),
    );

    await tester.pump();

    expect(find.byType(BlocBuilder<LoadedNotiBloc, LoadedNotiState>), findsOneWidget);
  });
}
