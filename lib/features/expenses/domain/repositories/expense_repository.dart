import '../entities/expense.dart';
import '../entities/recurring_expense_rule.dart';

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

  // Recurring Expenses
  Future<List<RecurringExpenseRule>> getRecurringRules();
  Future<RecurringExpenseRule> createRecurringRule(RecurringExpenseRule rule);
  Future<RecurringExpenseRule> updateRecurringRule(String id, RecurringExpenseRule rule);
  Future<void> deleteRecurringRule(String id);
}
