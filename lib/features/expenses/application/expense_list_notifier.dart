import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/expense.dart';
import '../domain/repositories/expense_repository.dart';
import '../infrastructure/expenses_infrastructure_providers.dart';

class ExpenseFiltersState {
  final DateTime from;
  final DateTime to;
  final String? categoryId;
  final String? tagId;
  final String? search;
  final String sortBy;
  final String sortOrder;

  ExpenseFiltersState({
    required this.from,
    required this.to,
    this.categoryId,
    this.tagId,
    this.search,
    this.sortBy = 'date',
    this.sortOrder = 'desc',
  });

  ExpenseFiltersState copyWith({
    DateTime? from,
    DateTime? to,
    String? categoryId,
    String? tagId,
    String? search,
    String? sortBy,
    String? sortOrder,
  }) {
    return ExpenseFiltersState(
      from: from ?? this.from,
      to: to ?? this.to,
      categoryId: categoryId == 'all' ? null : (categoryId ?? this.categoryId),
      tagId: tagId == 'all' ? null : (tagId ?? this.tagId),
      search: search ?? this.search,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

class ExpenseListNotifier extends StateNotifier<AsyncValue<List<Expense>>> {
  final ExpenseRepository _repository;
  ExpenseFiltersState _filters;

  ExpenseListNotifier(this._repository, this._filters) : super(const AsyncValue.loading()) {
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getExpenses(
          from: _filters.from,
          to: _filters.to,
          categoryId: _filters.categoryId,
          tagId: _filters.tagId,
          search: _filters.search,
          sortBy: _filters.sortBy,
          sortOrder: _filters.sortOrder,
        ));
  }

  void updateFilters(ExpenseFiltersState filters) {
    _filters = filters;
    loadExpenses();
  }
}

final expenseFiltersProvider = StateProvider<ExpenseFiltersState>((ref) {
  final now = DateTime.now();
  return ExpenseFiltersState(
    from: DateTime(now.year, now.month, 1),
    to: DateTime(now.year, now.month + 1, 0),
  );
});

final expenseListProvider = StateNotifierProvider<ExpenseListNotifier, AsyncValue<List<Expense>>>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  final filters = ref.watch(expenseFiltersProvider);
  return ExpenseListNotifier(repository, filters);
});
