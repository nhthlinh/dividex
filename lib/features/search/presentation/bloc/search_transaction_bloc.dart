import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/event_expense/data/models/expense_model.dart';
import 'package:Dividex/features/event_expense/domain/expense_usecase.dart';
import 'package:Dividex/features/recharge/data/models/recharge_model.dart';
import 'package:Dividex/features/recharge/domain/usecase.dart';
import 'package:Dividex/features/search/data/model/filter_model.dart';
import 'package:Dividex/shared/widgets/push_noti_in_app_widget.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum SearchTransactionTypeEnum { expense, external, internal, all }

abstract class SearchTransactionEvent extends Equatable {
  const SearchTransactionEvent();

  @override
  List<Object?> get props => [];
}

class InitialEvent extends SearchTransactionEvent {
  final SearchTransactionTypeEnum type;
  final ExpenseFilterArguments? expenseFilter;
  final ExternalTransactionFilterArguments? externalFilter;
  final InternalTransactionFilterArguments? internalFilter;

  const InitialEvent(
    this.type,
    this.expenseFilter,
    this.externalFilter,
    this.internalFilter,
  );
}

class LoadMoreTransactionsEvent extends SearchTransactionEvent {
  final SearchTransactionTypeEnum type;
  final ExpenseFilterArguments? expenseFilter;
  final ExternalTransactionFilterArguments? externalFilter;
  final InternalTransactionFilterArguments? internalFilter;
  const LoadMoreTransactionsEvent(
    this.type,
    this.expenseFilter,
    this.externalFilter,
    this.internalFilter,
  );
}

class RefreshTransactionsEvent extends SearchTransactionEvent {
  final SearchTransactionTypeEnum type;
  final ExpenseFilterArguments? expenseFilter;
  final ExternalTransactionFilterArguments? externalFilter;
  final InternalTransactionFilterArguments? internalFilter;

  const RefreshTransactionsEvent(
    this.type,
    this.expenseFilter,
    this.externalFilter,
    this.internalFilter,
  );
}

class SearchTransactionsState extends Equatable {
  const SearchTransactionsState({
    this.isLoading = true,
    this.page = 1,
    this.totalPage = 0,
    this.totalItems = 0,
    this.expense = const [],
    this.externalTransactions = const [],
    this.internalTransactions = const [],
  });

  final bool isLoading;
  final int page;
  final int totalPage;
  final int totalItems;
  final List<ExpenseModel> expense;
  final List<ExternalTransactionModel> externalTransactions;
  final List<InternalTransactionModel> internalTransactions;

  @override
  List<Object?> get props => [
    isLoading,
    page,
    totalPage,
    totalItems,
    expense,
    externalTransactions,
    internalTransactions,
  ];

  SearchTransactionsState copyWith({
    bool? isLoading,
    int? page,
    int? totalPage,
    int? totalItems,
    List<ExpenseModel>? expense,
    List<ExternalTransactionModel>? externalTransactions,
    List<InternalTransactionModel>? internalTransactions,
  }) {
    return SearchTransactionsState(
      isLoading: isLoading ?? this.isLoading,
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
      expense: expense ?? this.expense,
      externalTransactions: externalTransactions ?? this.externalTransactions,
      internalTransactions: internalTransactions ?? this.internalTransactions,
      totalItems: totalItems ?? this.totalItems,
    );
  }
}

class SearchTransactionBloc
    extends Bloc<SearchTransactionEvent, SearchTransactionsState> {
  SearchTransactionBloc() : super((const SearchTransactionsState())) {
    on<InitialEvent>(_onInitial);
    on<LoadMoreTransactionsEvent>(_onLoadMoreTransactions);
    on<RefreshTransactionsEvent>(_onRefreshTransactions);
  }

  Future<void> _onInitial(
    InitialEvent event,
    Emitter<SearchTransactionsState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));

      switch (event.type) {
        case SearchTransactionTypeEnum.expense:
          final useCase = await getIt.getAsync<ExpenseUseCase>();
          final expenses = await useCase.listAllExpenses(
            1,
            20,
            event.expenseFilter,
          );
          emit(
            state.copyWith(
              expense: expenses.data,
              page: expenses.page,
              totalPage: expenses.totalPage,
              totalItems: expenses.totalItems,
              isLoading: false,
            ),
          );
          break;

        case SearchTransactionTypeEnum.external:
          final useCase = await getIt.getAsync<RechargeUseCase>();
          final external = await useCase.getExternalHistory(
            1,
            20,
            event.externalFilter,
          );
          emit(
            state.copyWith(
              externalTransactions: List<ExternalTransactionModel>.from(
                external.data,
              ),
              page: external.page,
              totalPage: external.totalPage,
              totalItems: external.totalItems,
              isLoading: false,
            ),
          );
          break;

        case SearchTransactionTypeEnum.internal:
          final useCase = await getIt.getAsync<RechargeUseCase>();
          final internal = await useCase.getInternalHistory(
            1,
            20,
            event.internalFilter,
          );
          emit(
            state.copyWith(
              internalTransactions: List<InternalTransactionModel>.from(
                internal.data,
              ),
              page: internal.page,
              totalPage: internal.totalPage,
              totalItems: internal.totalItems,
              isLoading: false,
            ),
          );
          break;

        case SearchTransactionTypeEnum.all:
          final expenseUseCase = await getIt.getAsync<ExpenseUseCase>();
          final rechargeUseCase = await getIt.getAsync<RechargeUseCase>();

          final results = await Future.wait([
            expenseUseCase.listAllExpenses(1, 20, event.expenseFilter),
            rechargeUseCase.getExternalHistory(1, 10, event.externalFilter),
            rechargeUseCase.getInternalHistory(1, 10, event.internalFilter),
          ]);

          emit(
            state.copyWith(
              page: 1,
              totalPage: 1,
              expense: List<ExpenseModel>.from(results[0].data),
              externalTransactions: List<ExternalTransactionModel>.from(
                results[1].data,
              ),
              internalTransactions: List<InternalTransactionModel>.from(
                results[2].data,
              ),
              isLoading: false,
            ),
          );
          break;
      }
    } catch (e, s) {
      print('Search error: $e\n$s');
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onLoadMoreTransactions(
    LoadMoreTransactionsEvent event,
    Emitter<SearchTransactionsState> emit,
  ) async {
    if (state.isLoading || state.page >= state.totalPage) return;

    try {
      emit(state.copyWith(isLoading: true));

      switch (event.type) {
        case SearchTransactionTypeEnum.expense:
          final useCase = await getIt.getAsync<ExpenseUseCase>();
          final nextPage = state.page + 1;
          final expenses = await useCase.listAllExpenses(
            nextPage,
            20,
            event.expenseFilter,
          );
          emit(
            state.copyWith(
              expense: [...state.expense, ...expenses.data],
              page: expenses.page,
              totalPage: expenses.totalPage,
              totalItems: expenses.totalItems,
              isLoading: false,
            ),
          );
          break;

        case SearchTransactionTypeEnum.external:
          final useCase = await getIt.getAsync<RechargeUseCase>();
          final nextPage = state.page + 1;
          final external = await useCase.getExternalHistory(
            nextPage,
            20,
            event.externalFilter,
          );
          emit(
            state.copyWith(
              externalTransactions: [
                ...state.externalTransactions,
                ...List<ExternalTransactionModel>.from(external.data),
              ],
              page: external.page,
              totalPage: external.totalPage,
              totalItems: external.totalItems,
              isLoading: false,
            ),
          );
          break;

        case SearchTransactionTypeEnum.internal:
          final useCase = await getIt.getAsync<RechargeUseCase>();
          final nextPage = state.page + 1;
          final internal = await useCase.getInternalHistory(
            nextPage,
            20,
            event.internalFilter,
          );
          emit(
            state.copyWith(
              internalTransactions: [
                ...state.internalTransactions,
                ...List<InternalTransactionModel>.from(internal.data),
              ],
              page: internal.page,
              totalPage: internal.totalPage,
              totalItems: internal.totalItems,
              isLoading: false,
            ),
          );
          break;

        case SearchTransactionTypeEnum.all:
          emit(state.copyWith(isLoading: false));
          break;
      }
    } catch (e, s) {
      print('LoadMore error: $e\n$s');
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onRefreshTransactions(
    RefreshTransactionsEvent event,
    Emitter<SearchTransactionsState> emit,
  ) async {
    if (state.isLoading) return;

    try {
      emit(state.copyWith(isLoading: true));

      switch (event.type) {
        case SearchTransactionTypeEnum.expense:
          final useCase = await getIt.getAsync<ExpenseUseCase>();
          final refreshed = await useCase.listAllExpenses(
            1,
            20,
            event.expenseFilter,
          );
          emit(
            state.copyWith(
              expense: refreshed.data,
              page: refreshed.page,
              totalPage: refreshed.totalPage,
              totalItems: refreshed.totalItems,
              isLoading: false,
            ),
          );
          break;

        case SearchTransactionTypeEnum.external:
          final useCase = await getIt.getAsync<RechargeUseCase>();
          final refreshed = await useCase.getExternalHistory(
            1,
            20,
            event.externalFilter,
          );
          emit(
            state.copyWith(
              externalTransactions: List<ExternalTransactionModel>.from(
                refreshed.data,
              ),
              page: refreshed.page,
              totalPage: refreshed.totalPage,
              totalItems: refreshed.totalItems,
              isLoading: false,
            ),
          );
          break;

        case SearchTransactionTypeEnum.internal:
          final useCase = await getIt.getAsync<RechargeUseCase>();
          final refreshed = await useCase.getInternalHistory(
            1,
            20,
            event.internalFilter,
          );
          emit(
            state.copyWith(
              internalTransactions: List<InternalTransactionModel>.from(
                refreshed.data,
              ),
              page: refreshed.page,
              totalPage: refreshed.totalPage,
              totalItems: refreshed.totalItems,
              isLoading: false,
            ),
          );
          break;

        case SearchTransactionTypeEnum.all:
          // Refresh tất cả cùng lúc
          final expenseUseCase = await getIt.getAsync<ExpenseUseCase>();
          final rechargeUseCase = await getIt.getAsync<RechargeUseCase>();

          final results = await Future.wait([
            expenseUseCase.listAllExpenses(1, 20, event.expenseFilter),
            rechargeUseCase.getExternalHistory(1, 10, event.externalFilter),
            rechargeUseCase.getInternalHistory(1, 10, event.internalFilter),
          ]);

          emit(
            state.copyWith(
              expense: List<ExpenseModel>.from(results[0].data),
              externalTransactions: List<ExternalTransactionModel>.from(
                results[1].data,
              ),
              internalTransactions: List<InternalTransactionModel>.from(
                results[2].data,
              ),
              page: 1,
              totalPage: 1,
              isLoading: false,
            ),
          );
          break;
      }
    } catch (e, s) {
      print('Refresh error: $e\n$s');
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
      emit(state.copyWith(isLoading: false));
    }
  }
}
