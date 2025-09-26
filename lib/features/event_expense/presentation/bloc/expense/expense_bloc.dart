
import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/event_expense/data/models/expense_model.dart';
import 'package:Dividex/features/event_expense/domain/expense_usecase.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_event.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_state.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/utils/message_code.dart';
import 'package:Dividex/shared/widgets/push_noti_in_app_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  ExpenseBloc() : super((ExpenseState())) {
    on<CreateExpenseEvent>(_onCreateEvent);
    on<UpdateExpenseEvent>(_onUpdateEvent);
    on<DeleteExpenseEvent>(_onDeleteEvent);
  }

  Future _onCreateEvent(CreateExpenseEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<ExpenseUseCase>();
      await useCase.createExpense(
        event.name,
        event.totalAmount,
        event.currency,
        event.category,
        event.eventId,
        event.paidById,
        event.note,
        event.expenseDate,
        event.remindAt,
        event.splitType,
        event.userDebts,
      );

      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.success, type: ToastType.success);
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;

      if (e.toString().contains(MessageCode.groupNotFound)) {
        showCustomToast(intl.groupNotFound, type: ToastType.error);
      } else {
        showCustomToast(intl.error, type: ToastType.error);
      }
    }
  }

  Future _onUpdateEvent(UpdateExpenseEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<ExpenseUseCase>();
      await useCase.updateExpense(
        ExpenseModel(
          id: event.expenseId,
          name: event.name,
          totalAmount: event.totalAmount,
          currency: CurrencyEnum.values.firstWhere((e) => e.name == event.currency, orElse: () => CurrencyEnum.values.first),
          category: event.category,
          paidBy: event.paidById,
          note: event.note,
          expenseDate: event.expenseDate != null ? DateTime.tryParse(event.expenseDate!) : null,
          remindAt: event.remindAt != null ? DateTime.tryParse(event.remindAt!) : null,
          splitType: event.splitType,
          userDebts: event.userDebts,
        )
      );

      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.success, type: ToastType.success);
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;

      if (e.toString().contains(MessageCode.updateIsDenied)) {
        showCustomToast(intl.updateIsDenied, type: ToastType.error);
      } else if (e.toString().contains(MessageCode.expenseNotFound)) {
        showCustomToast(intl.expenseNotFound, type: ToastType.error);
      } else {
        showCustomToast(intl.error, type: ToastType.error);
      }
    }
  }

  Future _onDeleteEvent(DeleteExpenseEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<ExpenseUseCase>();
      await useCase.deleteExpense(event.expenseId);

      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.success, type: ToastType.success);
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;

      if (e.toString().contains(MessageCode.deleteIsDenied)) {
        showCustomToast(intl.deleteIsDenied, type: ToastType.error);
      } else if (e.toString().contains(MessageCode.eventNotFound)) {
        showCustomToast(intl.eventNotFound, type: ToastType.error);
      } else {
        showCustomToast(intl.error, type: ToastType.error);
      }
    }
  }
}

class ExpenseDataBloc extends Bloc<ExpenseEvent, ExpenseDataState> {
  ExpenseDataBloc() : super((ExpenseDataState())) {
    on<InitialEvent>(_onInitialEvent);
    on<LoadMoreExpenses>(_onLoadMoreExpenses);
    on<RefreshExpenses>(_onRefreshExpenses);
  }
  
  Future _onInitialEvent(InitialEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<ExpenseUseCase>();
      final expenses = event.type == LoadExpenseType.group 
        ? await useCase.listExpensesInGroup(event.id, event.page, event.pageSize)
        : await useCase.listExpensesInEvent(event.id, event.page, event.pageSize);

      emit(
        state.copyWith(
          page: expenses.page,
          totalPage: expenses.totalPage,
          expenses: expenses.data,
          totalItems: expenses.totalItems,
          isLoading: false,
        ),
      );
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future _onLoadMoreExpenses(LoadMoreExpenses event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<ExpenseUseCase>();
      final expenses = event.type == LoadExpenseType.group 
        ? await useCase.listExpensesInGroup(event.id, event.page, event.pageSize)
        : await useCase.listExpensesInEvent(event.id, event.page, event.pageSize);

      emit(
        state.copyWith(
          page: expenses.page,
          totalPage: expenses.totalPage,
          totalItems: expenses.totalItems,
          expenses: [...state.expenses, ...expenses.data],
        ),
      );
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }

  Future _onRefreshExpenses(RefreshExpenses event, Emitter emit) async {
    if (state.isLoading) return;

    try {
      emit(state.copyWith(isLoading: true));

      final useCase = await getIt.getAsync<ExpenseUseCase>();
      final expenses = event.type == LoadExpenseType.group 
        ? await useCase.listExpensesInGroup(event.id, event.page, event.pageSize)
        : await useCase.listExpensesInEvent(event.id, event.page, event.pageSize);


      emit(
        state.copyWith(
          page: expenses.page,
          totalPage: expenses.totalPage,
          expenses: expenses.data,
          totalItems: expenses.totalItems,
          isLoading: false,
        ),
      );
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;
      showCustomToast(intl.error, type: ToastType.error);
    }
  }
}