import '../../domain/entities/income.dart';
import '../../domain/repositories/income_repository.dart';
import '../datasources/income_remote_data_source.dart';

class IncomeRepositoryImpl implements IncomeRepository {
  final IncomeRemoteDataSource _remoteDataSource;

  IncomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Income>> getIncomes({DateTime? from, DateTime? to}) {
    return _remoteDataSource.getIncomes(from: from, to: to);
  }

  @override
  Future<Income> createIncome(Income income) {
    return _remoteDataSource.createIncome(income);
  }

  @override
  Future<Income> updateIncome(Income income) {
    return _remoteDataSource.updateIncome(income);
  }

  @override
  Future<void> deleteIncome(String id) {
    return _remoteDataSource.deleteIncome(id);
  }
}
