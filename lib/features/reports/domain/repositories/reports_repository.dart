import '../entities/report.dart';

abstract class ReportsRepository {
  Future<TimeRangeReport> getSpendingSummary({
    required DateTime from,
    required DateTime to,
    List<String>? categoryIds,
    List<String>? tagIds,
  });

  Future<TrendReport> getSpendingTrends({
    required DateTime from,
    required DateTime to,
    required String granularity,
  });
}
