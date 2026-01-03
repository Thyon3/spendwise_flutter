import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/network_providers.dart';
import '../domain/repositories/budget_repository.dart';
import 'data_sources/budgets_remote_data_source.dart';
import 'repositories/budget_repository_impl.dart';

final budgetsRemoteDataSourceProvider = Provider<BudgetsRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return BudgetsRemoteDataSource(apiClient);
});

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  final remoteDataSource = ref.watch(budgetsRemoteDataSourceProvider);
  return BudgetRepositoryImpl(remoteDataSource);
});
