import '../../domain/entities/report.dart';
import '../../domain/repositories/reports_repository.dart';
import '../data_sources/reports_remote_data_source.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  final ReportsRemoteDataSource _remoteDataSource;

  ReportsRepositoryImpl(this._remoteDataSource);

  @override
  Future<TimeRangeReport> getSpendingSummary({
    required DateTime from,
    required DateTime to,
    List<String>? categoryIds,
    List<String>? tagIds,
  }) =>
      _remoteDataSource.getSpendingSummary(
        from: from,
        to: to,
        categoryIds: categoryIds,
        tagIds: tagIds,
      );

  @override
  Future<TrendReport> getSpendingTrends({
    required DateTime from,
    required DateTime to,
    required String granularity,
  }) =>
      _remoteDataSource.getSpendingTrends(
        from: from,
        to: to,
        granularity: granularity,
      );
}
