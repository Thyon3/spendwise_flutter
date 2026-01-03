import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../data_sources/expenses_remote_data_source.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpensesRemoteDataSource _remoteDataSource;

  ExpenseRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Expense>> getExpenses({
    DateTime? from,
    DateTime? to,
    String? categoryId,
    int? page,
    int? limit,
  }) =>
      _remoteDataSource.getExpenses(
        from: from,
        to: to,
        categoryId: categoryId,
        page: page,
        limit: limit,
      );

  @override
  Future<Expense> createExpense(Expense expense) => _remoteDataSource.createExpense(expense);

  @override
  Future<Expense> updateExpense(String id, Expense expense) => _remoteDataSource.updateExpense(id, expense);

  @override
  Future<void> deleteExpense(String id) => _remoteDataSource.deleteExpense(id);

  @override
  Future<ExpenseSummary> getSummary(DateTime from, DateTime to) => _remoteDataSource.getSummary(from, to);
}
