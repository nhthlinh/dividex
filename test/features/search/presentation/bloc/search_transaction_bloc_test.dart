import 'dart:async';

import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/event_expense/data/models/expense_model.dart';
import 'package:Dividex/features/event_expense/domain/expense_usecase.dart';
import 'package:Dividex/features/recharge/data/models/recharge_model.dart';
import 'package:Dividex/features/recharge/domain/usecase.dart';
import 'package:Dividex/features/search/presentation/bloc/search_transaction_bloc.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockExpenseUseCase extends Mock implements ExpenseUseCase {}

class _MockRechargeUseCase extends Mock implements RechargeUseCase {}

void main() {
  late ExpenseUseCase expenseUseCase;
  late RechargeUseCase rechargeUseCase;

  setUp(() async {
    await getIt.reset();
    expenseUseCase = _MockExpenseUseCase();
    rechargeUseCase = _MockRechargeUseCase();
    getIt.registerSingletonAsync<ExpenseUseCase>(() async => expenseUseCase);
    getIt.registerSingletonAsync<RechargeUseCase>(() async => rechargeUseCase);
    await getIt.allReady();
  });

  tearDown(() async {
    await getIt.reset();
  });

  test('InitialEvent expense emits expense results', () async {
    when(() => expenseUseCase.listAllExpenses(1, 20, null)).thenAnswer(
      (_) async => PagingModel<List<ExpenseModel>>(
        data: <ExpenseModel>[],
        page: 1,
        totalPage: 1,
        totalItems: 0,
      ),
    );

    final bloc = SearchTransactionBloc();
    final completer = Completer<void>();
    late SearchTransactionsState emitted;
    final sub = bloc.stream.listen((state) {
      emitted = state;
      if (!state.isLoading && !completer.isCompleted) {
        completer.complete();
      }
    });

    bloc.add(const InitialEvent(SearchTransactionTypeEnum.expense, null, null, null));
    await completer.future;

    expect(emitted.isLoading, false);
    expect(emitted.expense, isEmpty);
    verify(() => expenseUseCase.listAllExpenses(1, 20, null)).called(1);
    verifyNever(() => rechargeUseCase.getExternalHistory(any(), any(), any()));

    await sub.cancel();
    await bloc.close();
  });

  test('InitialEvent external emits external transaction results', () async {
    when(() => rechargeUseCase.getExternalHistory(1, 20, null)).thenAnswer(
      (_) async => PagingModel<List<ExternalTransactionModel>>(
        data: <ExternalTransactionModel>[],
        page: 1,
        totalPage: 1,
        totalItems: 0,
      ),
    );

    final bloc = SearchTransactionBloc();
    bloc.add(const InitialEvent(SearchTransactionTypeEnum.external, null, null, null));
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(bloc.state.isLoading, false);
    expect(bloc.state.externalTransactions, isEmpty);
    verify(() => rechargeUseCase.getExternalHistory(1, 20, null)).called(1);
    await bloc.close();
  });
}
