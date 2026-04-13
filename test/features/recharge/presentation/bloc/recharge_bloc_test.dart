import 'dart:async';

import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/recharge/data/models/recharge_model.dart';
import 'package:Dividex/features/recharge/domain/usecase.dart';
import 'package:Dividex/features/recharge/presentation/bloc/recharge_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRechargeUseCase extends Mock implements RechargeUseCase {}

void main() {
  late RechargeUseCase useCase;

  setUp(() async {
    await getIt.reset();
    useCase = _MockRechargeUseCase();
    getIt.registerSingletonAsync<RechargeUseCase>(() async => useCase);
    await getIt.isReady<RechargeUseCase>();
  });

  tearDown(() async {
    await getIt.reset();
  });

  test('DepositEvent emits PayOsCheckOutLinkState', () async {
    final response = PayOSResponseModel(
      orderCode: 123,
      qrCode: 'qr-data',
      paymentLinkId: 'plink-1',
    );
    when(() => useCase.deposit(20000, 'VND')).thenAnswer((_) async => response);

    final bloc = RechargeBloc();
    final completer = Completer<void>();
    late RechargeState emitted;
    final sub = bloc.stream.listen((state) {
      emitted = state;
      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    bloc.add(DepositEvent(20000, 'VND'));
    await completer.future;

    expect(emitted, isA<PayOsCheckOutLinkState>());
    expect((emitted as PayOsCheckOutLinkState).link.orderCode, 123);
    verify(() => useCase.deposit(20000, 'VND')).called(1);

    await sub.cancel();
    await bloc.close();
  });

  test('GetWalletEvent emits GetWalletSuccessState', () async {
    when(() => useCase.getWallet()).thenAnswer((_) async => '120000');

    final bloc = RechargeBloc();
    bloc.add(GetWalletEvent());
    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(bloc.state, isA<GetWalletSuccessState>());
    expect((bloc.state as GetWalletSuccessState).walletInfo, '120000');
    verify(() => useCase.getWallet()).called(1);
    await bloc.close();
  });
}
