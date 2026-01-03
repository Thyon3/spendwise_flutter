import '../../domain/entities/budget.dart';
import '../../domain/repositories/budget_repository.dart';
import '../data_sources/budgets_remote_data_source.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetsRemoteDataSource _remoteDataSource;

  BudgetRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Budget>> getBudgets() => _remoteDataSource.getBudgets();

  @override
  Future<Budget> createBudget(Budget budget) => _remoteDataSource.createBudget(budget);

  @override
  Future<Budget> updateBudget(String id, Budget budget) => _remoteDataSource.updateBudget(id, budget);

  @override
  Future<void> deleteBudget(String id) => _remoteDataSource.deleteBudget(id);

  @override
  Future<List<BudgetStatus>> getBudgetStatuses() => _remoteDataSource.getBudgetStatuses();
}
