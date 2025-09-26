import 'package:Dividex/features/event_expense/data/models/expense_model.dart';
import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:equatable/equatable.dart';

class ExpenseState {}

class ExpenseLoadedState extends ExpenseState {
  final ExpenseModel expense;

  ExpenseLoadedState({required this.expense});
}

class ExpenseDataState extends Equatable {
  const ExpenseDataState({
    this.isLoading = true,
    this.page = 0,
    this.totalPage = 0,
    this.totalItems = 0,
    this.expenses = const [],
  });

  final bool isLoading;
  final int page;
  final int totalPage;
  final int totalItems;
  final List<ExpenseModel> expenses;

  @override
  List<Object?> get props => [isLoading, page, totalPage, totalItems, expenses];

  ExpenseDataState copyWith({
    bool? isLoading,
    int? page,
    int? totalPage,
    int? totalItems,
    List<ExpenseModel>? expenses,
  }) {
    return ExpenseDataState(
      isLoading: isLoading ?? this.isLoading,
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
      totalItems: totalItems ?? this.totalItems,
      expenses: expenses ?? this.expenses,
    );
  }
}
