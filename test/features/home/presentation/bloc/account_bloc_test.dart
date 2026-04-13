import 'dart:async';

import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/home/data/models/bank_account_model.dart';
import 'package:Dividex/features/home/domain/usecase.dart';
import 'package:Dividex/features/home/presentation/bloc/account/account_bloc.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAccountUseCase extends Mock implements AccountUseCase {}

void main() {
  late AccountUseCase useCase;

  setUp(() async {
    await getIt.reset();
    useCase = _MockAccountUseCase();
    getIt.registerSingletonAsync<AccountUseCase>(() async => useCase);
    await getIt.isReady<AccountUseCase>();
  });

  tearDown(() async {
    await getIt.reset();
  });

  test('GetAccountsEvent emits AccountState with fetched accounts', () async {
    when(
      () => useCase.getAccounts(1, 1000),
    ).thenAnswer(
      (_) async => <BankAccount>[
        BankAccount(
          id: 'acc-1',
          accountNumber: '123',
          bankName: 'VCB',
          currency: CurrencyEnum.vnd,
        ),
      ],
    );

    final bloc = AccountBloc();
    final completer = Completer<void>();
    late AccountState emitted;
    final sub = bloc.stream.listen((state) {
      emitted = state;
      if (state.accounts.isNotEmpty && !completer.isCompleted) {
        completer.complete();
      }
    });

    bloc.add(GetAccountsEvent());
    await completer.future;

    expect(emitted.accounts.length, 1);
    expect(emitted.accounts.first.id, 'acc-1');
    verify(() => useCase.getAccounts(1, 1000)).called(1);

    await sub.cancel();
    await bloc.close();
  });
}
