import '../../../../core/network/api_client.dart';
import '../../domain/entities/budget.dart';

class BudgetsRemoteDataSource {
  final ApiClient _client;

  BudgetsRemoteDataSource(this._client);

  Future<List<Budget>> getBudgets() async {
    final response = await _client.get('/budgets');
    return (response.data as List).map((b) => Budget.fromJson(b)).toList();
  }

  Future<Budget> createBudget(Budget budget) async {
    final response = await _client.post('/budgets', data: {
      'name': budget.name,
      'amountLimit': budget.amountLimit,
      'currency': budget.currency,
      'periodType': budget.periodType.name,
      'periodStart': budget.periodStart?.toIso8601String(),
      'periodEnd': budget.periodEnd?.toIso8601String(),
      'categoryId': budget.categoryId,
    });
    return Budget.fromJson(response.data);
  }

  Future<Budget> updateBudget(String id, Budget budget) async {
    final response = await _client.put('/budgets/$id', data: {
      'name': budget.name,
      'amountLimit': budget.amountLimit,
      'currency': budget.currency,
      'periodType': budget.periodType.name,
      'periodStart': budget.periodStart?.toIso8601String(),
      'periodEnd': budget.periodEnd?.toIso8601String(),
      'categoryId': budget.categoryId,
    });
    return Budget.fromJson(response.data);
  }

  Future<void> deleteBudget(String id) async {
    await _client.delete('/budgets/$id');
  }

  Future<List<BudgetStatus>> getBudgetStatuses() async {
    final response = await _client.get('/budgets/status');
    return (response.data as List).map((s) => BudgetStatus.fromJson(s)).toList();
  }
}
