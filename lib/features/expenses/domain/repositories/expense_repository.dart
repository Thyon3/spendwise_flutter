import '../entities/expense.dart';

abstract class ExpenseRepository {
  Future<List<Expense>> getExpenses({
    DateTime? from,
    DateTime? to,
    String? categoryId,
    int? page,
    int? limit,
  });
  Future<Expense> createExpense(Expense expense);
  Future<Expense> updateExpense(String id, Expense expense);
  Future<void> deleteExpense(String id);
  Future<ExpenseSummary> getSummary(DateTime from, DateTime to);
}
