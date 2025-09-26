import 'dart:math';

import 'package:Dividex/core/network/dio_client.dart';
import 'package:Dividex/features/event_expense/data/models/expense_model.dart';
import 'package:Dividex/features/event_expense/data/models/user_debt.dart';
import 'package:Dividex/features/event_expense/data/source/expense_remote_datasource.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ExpenseRemoteDataSource)
class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  final DioClient dio;

  ExpenseRemoteDataSourceImpl(this.dio);

  @override
  Future<void> createExpense(
    String name,
    double totalAmount,
    String currency,
    String category,
    String eventId,
    String? paidById,
    String? note,
    String? expenseDate,
    String? remindAt,
    SplitTypeEnum splitType,
    List<UserDebt> userDebts,
  ) async {
    return apiCallWrapper(() {
      return dio.post(
        '/expenses',
        data: {
          'name': name,
          'total_amount': totalAmount,
          'currency': currency,
          'category': category,
          'event_uid': eventId,
          if (paidById != null) 'paid_by': paidById,
          if (note != null) 'note': note,
          if (expenseDate != null) 'expense_date': expenseDate,
          if (remindAt != null) 'remind_at': remindAt,
          'split_type': splitType.toString().split('.').last.toUpperCase(),
          'list_expense_member': userDebts.map((e) => e.toJson()).toList(),
        },
      );
    });
  }

  // API CHƯA HOÀN THIỆN
  @override
  Future<PagingModel<List<ExpenseModel>>> listExpensesInEvent(
    String eventId,
    int page,
    int pageSize,
  ) async {
    return apiCallWrapper(() async {
      final response = await dio.get(
        'expenses/event/$eventId',
        queryParameters: {'page': page, 'page_size': pageSize},
      );
      return PagingModel.fromJson(
        response.data,
        (data) =>
            (data as List).map((item) => ExpenseModel.fromJson(item)).toList(),
      );
    });
  }

  // API CHƯA HOÀN THIỆN
  @override
  Future<PagingModel<List<ExpenseModel>>> listExpensesInGroup(
    String groupId,
    int page,
    int pageSize,
  ) async {
    return apiCallWrapper(() async {
      final response = await dio.get(
        'expenses/group/$groupId',
        queryParameters: {'page': page, 'page_size': pageSize},
      );
      return PagingModel.fromJson(
        response.data,
        (data) =>
            (data as List).map((item) => ExpenseModel.fromJson(item)).toList(),
      );
    });
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    return apiCallWrapper(() async {
      await dio.put(
        '/expenses/${expense.id}',
        data: {
          'name': expense.name,
          'total_amount': expense.totalAmount,
          'currency': expense.currency,
          'category': expense.category,
          if (expense.paidBy != null) 'paid_by': expense.paidBy!,
          if (expense.note != null) 'note': expense.note,
          if (expense.expenseDate != null) 'expense_date': expense.expenseDate,
          if (expense.remindAt != null) 'remind_at': expense.remindAt,
          'split_type': expense.splitType
              .toString()
              .split('.')
              .last
              .toUpperCase(),
          'user_debts': expense.userDebts?.map((e) => e.toJson()).toList(),
        },
      );
    });
  }

  @override
  Future<void> deleteExpense(String id) async {
    return apiCallWrapper(() {
      return dio.delete('/expenses/$id');
    });
  }
}
