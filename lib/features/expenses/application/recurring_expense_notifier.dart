import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/recurring_expense_rule.dart';
import '../domain/repositories/expense_repository.dart';
import '../infrastructure/expenses_infrastructure_providers.dart';

class RecurringExpenseListNotifier extends StateNotifier<AsyncValue<List<RecurringExpenseRule>>> {
  final ExpenseRepository _repository;

  RecurringExpenseListNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadRules();
  }

  Future<void> loadRules() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getRecurringRules());
  }

  Future<void> createRule(RecurringExpenseRule rule) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.createRecurringRule(rule);
      return _repository.getRecurringRules();
    });
  }

  Future<void> updateRule(String id, RecurringExpenseRule rule) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.updateRecurringRule(id, rule);
      return _repository.getRecurringRules();
    });
  }

  Future<void> deleteRule(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.deleteRecurringRule(id);
      return _repository.getRecurringRules();
    });
  }
}

final recurringExpenseListProvider = StateNotifierProvider<RecurringExpenseListNotifier, AsyncValue<List<RecurringExpenseRule>>>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return RecurringExpenseListNotifier(repository);
});
