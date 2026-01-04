import '../../../../core/network/api_client.dart';
import '../../domain/entities/financial_summary.dart';

abstract class ReportsRemoteDataSource {
  Future<FinancialSummary> getFinancialSummary({required DateTime from, required DateTime to});
}

class ReportsRemoteDataSourceImpl implements ReportsRemoteDataSource {
  final ApiClient _apiClient;

  ReportsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<FinancialSummary> getFinancialSummary({required DateTime from, required DateTime to}) async {
    final response = await _apiClient.get(
      '/reports/financial-summary',
      queryParameters: {
        'from': from.toIso8601String(),
        'to': to.toIso8601String(),
      },
    );
    return FinancialSummary.fromJson(response.data);
  }
}
