import '../../../../core/network/api_client.dart';
import '../../domain/entities/income.dart';

abstract class IncomeRemoteDataSource {
  Future<List<Income>> getIncomes({DateTime? from, DateTime? to});
  Future<Income> createIncome(Income income);
  Future<Income> updateIncome(Income income);
  Future<void> deleteIncome(String id);
}

class IncomeRemoteDataSourceImpl implements IncomeRemoteDataSource {
  final ApiClient _apiClient;

  IncomeRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<Income>> getIncomes({DateTime? from, DateTime? to}) async {
    final queryParameters = <String, dynamic>{};
    if (from != null) queryParameters['from'] = from.toIso8601String();
    if (to != null) queryParameters['to'] = to.toIso8601String();

    final response = await _apiClient.get('/incomes', queryParameters: queryParameters);
    return (response.data as List).map((e) => Income.fromJson(e)).toList();
  }

  @override
  Future<Income> createIncome(Income income) async {
    final response = await _apiClient.post('/incomes', data: income.toJson());
    return Income.fromJson(response.data);
  }

  @override
  Future<Income> updateIncome(Income income) async {
    final response = await _apiClient.put('/incomes/${income.id}', data: income.toJson());
    return Income.fromJson(response.data);
  }

  @override
  Future<void> deleteIncome(String id) async {
    await _apiClient.delete('/incomes/$id');
  }
}
