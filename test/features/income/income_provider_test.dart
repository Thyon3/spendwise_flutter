import 'package:expense_tracker_frontend/features/income/domain/entities/income.dart';
import 'package:expense_tracker_frontend/features/income/domain/repositories/income_repository.dart';
import 'package:expense_tracker_frontend/features/income/presentation/providers/income_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class MockIncomeRepository implements IncomeRepository {
  List<Income> incomes = [];
  bool shouldThrow = false;

  @override
  Future<List<Income>> getIncomes({DateTime? from, DateTime? to}) async {
    if (shouldThrow) throw Exception('Error fetching incomes');
    return incomes;
  }

  @override
  Future<void> createIncome(Income income) async {
    if (shouldThrow) throw Exception('Error creating income');
    incomes.add(income);
  }

  @override
  Future<void> deleteIncome(String id) async {
    if (shouldThrow) throw Exception('Error deleting income');
    incomes.removeWhere((i) => i.id == id);
  }

  @override
  Future<void> updateIncome(Income income) async {
    if (shouldThrow) throw Exception('Error updating income');
    final index = incomes.indexWhere((i) => i.id == income.id);
    if (index != -1) {
      incomes[index] = income;
    }
  }
}

void main() {
  late MockIncomeRepository mockRepository;

  setUp(() {
    mockRepository = MockIncomeRepository();
  });

  test('loadIncomes updates state with fetched incomes', () async {
    final income = Income(id: '1', amount: 100, currency: 'USD', date: DateTime.now(), categoryId: 'c1');
    mockRepository.incomes = [income];

    final container = ProviderContainer(overrides: [
      incomeRepositoryProvider.overrideWithValue(mockRepository),
    ]);
    addTearDown(container.dispose);

    final notifier = container.read(incomeListProvider.notifier);
    await notifier.getIncomes();

    final state = container.read(incomeListProvider);
    if (state.hasError) {
      print('State Error: ${state.error}');
      print('State StackTrace: ${state.stackTrace}');
    }
    expect(state, isA<AsyncData<List<Income>>>());
    expect(state.value!.length, 1);
    expect(state.value![0].id, income.id);
  });

  test('addIncome adds income and reloads', () async {
    final container = ProviderContainer(overrides: [
      incomeRepositoryProvider.overrideWithValue(mockRepository),
    ]);
    addTearDown(container.dispose);

    final income = Income(id: '1', amount: 100, currency: 'USD', date: DateTime.now(), categoryId: 'c1');
    
    final notifier = container.read(incomeListProvider.notifier);
    await notifier.addIncome(income);

    expect(mockRepository.incomes.length, 1);
    expect(container.read(incomeListProvider).value?.length, 1);
  });
  
  test('deleteIncome removes income and reloads', () async {
      final income = Income(id: '1', amount: 100, currency: 'USD', date: DateTime.now(), categoryId: 'c1');
      mockRepository.incomes = [income];

      final container = ProviderContainer(overrides: [
        incomeRepositoryProvider.overrideWithValue(mockRepository),
      ]);
      addTearDown(container.dispose);

      final notifier = container.read(incomeListProvider.notifier);
      // Initial load
      await notifier.getIncomes();
      expect(container.read(incomeListProvider).value?.length, 1);

      await notifier.deleteIncome('1');
      expect(mockRepository.incomes.isEmpty, true);
      expect(container.read(incomeListProvider).value?.isEmpty, true);
  });
}
