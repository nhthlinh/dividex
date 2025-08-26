import 'package:Dividex/features/event_expense/data/source/expense_remote_datasource.dart';
import 'package:Dividex/features/event_expense/domain/expense_repository.dart';
import 'package:injectable/injectable.dart';


@Injectable(as: ExpenseRepository)
class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource remoteDataSource;

  ExpenseRepositoryImpl(this.remoteDataSource);

}
