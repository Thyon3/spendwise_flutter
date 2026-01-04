import '../../domain/entities/financial_summary.dart';
import '../datasources/reports_remote_data_source.dart';

abstract class ReportsRepository {
  Future<FinancialSummary> getFinancialSummary({required DateTime from, required DateTime to});
}

class ReportsRepositoryImpl implements ReportsRepository {
  final ReportsRemoteDataSource _remoteDataSource;

  ReportsRepositoryImpl(this._remoteDataSource);

  @override
  Future<FinancialSummary> getFinancialSummary({required DateTime from, required DateTime to}) {
    return _remoteDataSource.getFinancialSummary(from: from, to: to);
  }
}
