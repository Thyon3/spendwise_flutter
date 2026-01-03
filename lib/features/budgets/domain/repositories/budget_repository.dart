import '../entities/budget.dart';

abstract class BudgetRepository {
  Future<List<Budget>> getBudgets();
  Future<Budget> createBudget(Budget budget);
  Future<Budget> updateBudget(String id, Budget budget);
  Future<void> deleteBudget(String id);
  Future<List<BudgetStatus>> getBudgetStatuses();
}
