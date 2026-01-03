import '../../../../core/network/api_client.dart';
import '../../domain/entities/report.dart';

class ReportsRemoteDataSource {
  final ApiClient _client;

  ReportsRemoteDataSource(this._client);

  Future<TimeRangeReport> getSpendingSummary({
    required DateTime from,
    required DateTime to,
    List<String>? categoryIds,
    List<String>? tagIds,
  }) async {
    final query = <String, dynamic>{
      'from': from.toIso8601String(),
      'to': to.toIso8601String(),
    };

    if (categoryIds != null && categoryIds.isNotEmpty) {
      for (int i = 0; i < categoryIds.length; i++) {
        query['categoryIds[$i]'] = categoryIds[i];
      }
    }

    if (tagIds != null && tagIds.isNotEmpty) {
      for (int i = 0; i < tagIds.length; i++) {
        query['tagIds[$i]'] = tagIds[i];
      }
    }

    final response = await _client.get('/reports/summary', queryParameters: query);
    return TimeRangeReport.fromJson(response.data);
  }

  Future<TrendReport> getSpendingTrends({
    required DateTime from,
    required DateTime to,
    required String granularity,
  }) async {
    final response = await _client.get('/reports/trends', queryParameters: {
      'from': from.toIso8601String(),
      'to': to.toIso8601String(),
      'granularity': granularity,
    });
    return TrendReport.fromJson(response.data);
  }
}
