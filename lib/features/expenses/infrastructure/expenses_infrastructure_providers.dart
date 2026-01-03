import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/network_providers.dart';
import '../../domain/repositories/expense_repository.dart';
import '../../domain/repositories/tag_repository.dart';
import '../data_sources/expenses_remote_data_source.dart';
import '../repositories/expense_repository_impl.dart';
import '../repositories/tag_repository_impl.dart';

final expensesRemoteDataSourceProvider = Provider<ExpensesRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ExpensesRemoteDataSource(apiClient);
});

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  final remoteDataSource = ref.watch(expensesRemoteDataSourceProvider);
  return ExpenseRepositoryImpl(remoteDataSource);
});

final tagRepositoryProvider = Provider<TagRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TagRepositoryImpl(apiClient);
});
