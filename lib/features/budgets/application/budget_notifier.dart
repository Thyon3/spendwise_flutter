import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/budget.dart';
import '../domain/repositories/budget_repository.dart';
import '../infrastructure/budgets_infrastructure_providers.dart';

class BudgetListNotifier extends StateNotifier<AsyncValue<List<Budget>>> {
  final BudgetRepository _repository;

  BudgetListNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadBudgets();
  }

  Future<void> loadBudgets() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getBudgets());
  }

  Future<void> createBudget(Budget budget) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.createBudget(budget);
      return _repository.getBudgets();
    });
  }

  Future<void> updateBudget(String id, Budget budget) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.updateBudget(id, budget);
      return _repository.getBudgets();
    });
  }

  Future<void> deleteBudget(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.deleteBudget(id);
      return _repository.getBudgets();
    });
  }
}

class BudgetStatusNotifier extends StateNotifier<AsyncValue<List<BudgetStatus>>> {
  final BudgetRepository _repository;

  BudgetStatusNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadStatuses();
  }

  Future<void> loadStatuses() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getBudgetStatuses());
  }
}

final budgetListProvider = StateNotifierProvider<BudgetListNotifier, AsyncValue<List<Budget>>>((ref) {
  final repository = ref.watch(budgetRepositoryProvider);
  return BudgetListNotifier(repository);
});

final budgetStatusListProvider = StateNotifierProvider<BudgetStatusNotifier, AsyncValue<List<BudgetStatus>>>((ref) {
  final repository = ref.watch(budgetRepositoryProvider);
  return BudgetStatusNotifier(repository);
});
