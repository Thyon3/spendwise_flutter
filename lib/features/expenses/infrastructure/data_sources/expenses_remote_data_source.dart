import '../../../../core/network/api_client.dart';
import '../entities/expense.dart';

class ExpensesRemoteDataSource {
  final ApiClient _client;

  ExpensesRemoteDataSource(this._client);

  Future<List<Expense>> getExpenses({
    DateTime? from,
    DateTime? to,
    String? categoryId,
    int? page,
    int? limit,
  }) async {
    final Map<String, dynamic> query = {};
    if (from != null) query['from'] = from.toIso8601String();
    if (to != null) query['to'] = to.toIso8601String();
    if (categoryId != null) query['categoryId'] = categoryId;
    if (page != null) query['page'] = page;
    if (limit != null) query['limit'] = limit;

    final response = await _client.get('/expenses', queryParameters: query);
    return (response.data as List).map((e) => Expense.fromJson(e)).toList();
  }

  Future<Expense> createExpense(Expense expense) async {
    final response = await _client.post('/expenses', data: expense.toJson());
    return Expense.fromJson(response.data);
  }

  Future<Expense> updateExpense(String id, Expense expense) async {
    final response = await _client.put('/expenses/$id', data: expense.toJson());
    return Expense.fromJson(response.data);
  }

  Future<void> deleteExpense(String id) async {
    await _client.delete('/expenses/$id');
  }

  Future<ExpenseSummary> getSummary(DateTime from, DateTime to) async {
    final response = await _client.get('/expenses/summary', queryParameters: {
      'from': from.toIso8601String(),
      'to': to.toIso8601String(),
    });
    return ExpenseSummary.fromJson(response.data);
  }
}
