import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/expense.dart';
import '../domain/repositories/expense_repository.dart';
import '../infrastructure/expenses_infrastructure_providers.dart';
import 'expense_list_notifier.dart';
import 'expense_summary_notifier.dart';

class ExpenseOpsNotifier extends StateNotifier<AsyncValue<void>> {
  final ExpenseRepository _repository;
  final Ref _ref;

  ExpenseOpsNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<void> createExpense(Expense expense) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.createExpense(expense);
      _refreshDependencies();
    });
  }

  Future<void> updateExpense(String id, Expense expense) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.updateExpense(id, expense);
      _refreshDependencies();
    });
  }

  Future<void> deleteExpense(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.deleteExpense(id);
      _refreshDependencies();
    });
  }

  void _refreshDependencies() {
    _ref.read(expenseListProvider.notifier).loadExpenses();
    _ref.read(expenseSummaryProvider.notifier).loadSummary();
  }
}

final expenseOpsProvider = StateNotifierProvider<ExpenseOpsNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return ExpenseOpsNotifier(repository, ref);
});
