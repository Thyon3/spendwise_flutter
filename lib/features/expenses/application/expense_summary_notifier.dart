import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/expense.dart';
import '../domain/repositories/expense_repository.dart';
import '../infrastructure/expenses_infrastructure_providers.dart';
import 'expense_list_notifier.dart';

class ExpenseSummaryNotifier extends StateNotifier<AsyncValue<ExpenseSummary>> {
  final ExpenseRepository _repository;
  final ExpenseFiltersState _filters;

  ExpenseSummaryNotifier(this._repository, this._filters) : super(const AsyncValue.loading()) {
    loadSummary();
  }

  Future<void> loadSummary() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getSummary(_filters.from, _filters.to));
  }
}

final expenseSummaryProvider = StateNotifierProvider<ExpenseSummaryNotifier, AsyncValue<ExpenseSummary>>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  final filters = ref.watch(expenseFiltersProvider);
  return ExpenseSummaryNotifier(repository, filters);
});
