import 'package:Dividex/features/event_expense/data/models/event_model.dart';
import 'package:Dividex/features/event_expense/data/models/expense_model.dart';
import 'package:Dividex/features/event_expense/domain/event_repository.dart';
import 'package:Dividex/features/event_expense/domain/expense_repository.dart';
import 'package:Dividex/shared/models/paging_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExpenseUseCase {
  final ExpenseRepository repository;
  final EventRepository eventRepository;

  ExpenseUseCase(this.repository, this.eventRepository);

  Future<void> addExpense(ExpenseModel expense) async {
    await repository.addExpense(expense);
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    await repository.updateExpense(expense);
  }

  Future<void> deleteExpense(String id) async {
    await repository.deleteExpense(id);
  }

  Future<List<ExpenseModel>> getExpenses() async {
    return await repository.getExpenses();
  }

  Future<PagingModel<List<String>>> getCategories(int page, int pageSize, String key) async {
    return await repository.getCategories(page, pageSize, key);
  }

  Future<PagingModel<List<EventModel>>> getEvents(int groupId, int page, int pageSize) async {
    return await eventRepository.getEvents(groupId, page, pageSize);
  }
}
