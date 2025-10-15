import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/core/di/injection.dart';
import 'package:Dividex/features/event_expense/data/models/expense_model.dart';
import 'package:Dividex/features/event_expense/domain/event_usecase.dart';
import 'package:Dividex/features/event_expense/domain/expense_usecase.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/event/event_bloc.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/event/event_event.dart'
    as event_event;
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_event.dart';
import 'package:Dividex/features/event_expense/presentation/bloc/expense/expense_state.dart';
import 'package:Dividex/features/image/data/models/image_presign_url_model.dart';
import 'package:Dividex/features/image/presentation/bloc/image_bloc.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/utils/message_code.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/push_noti_in_app_widget.dart';
import 'package:Dividex/shared/widgets/show_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  ExpenseBloc() : super((ExpenseState())) {
    on<CreateExpenseEvent>(_onCreateEvent);
    on<UpdateExpenseEvent>(_onUpdateEvent);
    on<SoftDeleteExpenseEvent>(_onSoftDeleteEvent);
    on<HardDeleteExpenseEvent>(_onHardDeleteEvent);
    on<GetExpenseDetail>(_onGetExpenseDetailEvent);
  }

  Future _onCreateEvent(CreateExpenseEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<ExpenseUseCase>();
      final expenseId = await useCase.createExpense(
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

      if (event.images != null) {
        uploadImage(expenseId, event.images!, AttachmentType.expense);
      }
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
          currency: CurrencyEnum.values.firstWhere(
            (e) => e.name == event.currency,
            orElse: () => CurrencyEnum.values.first,
          ),
          category: event.category,
          paidBy: event.paidById,
          note: event.note,
          expenseDate: event.expenseDate != null
              ? DateTime.tryParse(event.expenseDate!)
              : null,
          remindAt: event.remindAt != null
              ? DateTime.tryParse(event.remindAt!)
              : null,
          splitType: event.splitType,
          userDebts: event.userDebts,
        ),
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

  Future _onSoftDeleteEvent(SoftDeleteExpenseEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<ExpenseUseCase>();
      await useCase.softDeleteExpense(event.expenseId);

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

  Future _onHardDeleteEvent(HardDeleteExpenseEvent event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<ExpenseUseCase>();
      await useCase.hardDeleteExpense(event.expenseId);

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

  Future _onGetExpenseDetailEvent(GetExpenseDetail event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<ExpenseUseCase>();
      final expense = await useCase.getExpenseDetail(event.expenseId);

      if (expense != null) {
        emit(ExpenseLoadedState(expense: expense));
      }
    } catch (e) {
      final intl = AppLocalizations.of(navigatorKey.currentContext!)!;

      if (e.toString().contains(MessageCode.expenseNotFound)) {
        showCustomToast(intl.expenseNotFound, type: ToastType.error);
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
          ? await useCase.listExpensesInGroup(
              event.id,
              event.page,
              event.pageSize,
              event.status!,
            )
          : await useCase.listExpensesInEvent(
              event.id,
              event.page,
              event.pageSize,
            );

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
      final theme = Theme.of(navigatorKey.currentContext!);

      showCustomToast(intl.error, type: ToastType.error);
      if (event.type == LoadExpenseType.event &&
          e.toString().contains(MessageCode.getIsDenied)) {
        final userId = HiveService.getUser().id;

        showCustomDialog(
          context: navigatorKey.currentContext!,
          content: Column(
            children: [
              RichText(
                text: TextSpan(
                  text: '',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
                  children: [
                    TextSpan(
                      text: intl.event_not_joined_title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppThemes.primary3Color,
                      ),
                    ),
                    TextSpan(
                      text: '\n${intl.event_not_joined_message}\n',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButton(
                    text: intl.cancel,
                    onPressed: () {
                      navigatorKey.currentContext!.pop();
                      // Trở về trang trước đó
                      navigatorKey.currentContext!.pop();
                    },
                    size: ButtonSize.medium,
                    type: ButtonType.secondary,
                    customColor: AppThemes.errorColor,
                  ),
                  CustomButton(
                    text: intl.join_button,
                    onPressed: () async {
                      final useCase = await getIt.getAsync<EventUseCase>();
                      await useCase.joinEvent(event.id, userId ?? '');
                      navigatorKey.currentContext!.pop();

                      add(
                        InitialEvent(
                          id: event.id,
                          type: event.type,
                          page: event.page,
                          pageSize: event.pageSize,
                          status: event.status,
                        ),
                      );
                    },
                    size: ButtonSize.medium,
                    customColor: AppThemes.primary3Color,
                  ),
                ],
              ),
            ],
          ),
        );
      }
    }
  }

  Future _onLoadMoreExpenses(LoadMoreExpenses event, Emitter emit) async {
    try {
      final useCase = await getIt.getAsync<ExpenseUseCase>();
      final expenses = event.type == LoadExpenseType.group
          ? await useCase.listExpensesInGroup(
              event.id,
              event.page,
              event.pageSize,
              event.status!,
            )
          : await useCase.listExpensesInEvent(
              event.id,
              event.page,
              event.pageSize,
            );

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
          ? await useCase.listExpensesInGroup(
              event.id,
              event.page,
              event.pageSize,
              event.status!,
            )
          : await useCase.listExpensesInEvent(
              event.id,
              event.page,
              event.pageSize,
            );

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
