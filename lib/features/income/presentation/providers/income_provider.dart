import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/network_providers.dart';
import '../../data/datasources/income_remote_data_source.dart';
import '../../data/repositories/income_repository_impl.dart';
import '../../domain/entities/income.dart';

final incomeRemoteDataSourceProvider = Provider<IncomeRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return IncomeRemoteDataSourceImpl(apiClient);
});

final incomeRepositoryProvider = Provider<IncomeRepositoryImpl>((ref) {
  final remote = ref.watch(incomeRemoteDataSourceProvider);
  return IncomeRepositoryImpl(remote);
});

final incomeListProvider = StateNotifierProvider<IncomeListNotifier, AsyncValue<List<Income>>>((ref) {
  return IncomeListNotifier(ref.watch(incomeRepositoryProvider));
});

class IncomeListNotifier extends StateNotifier<AsyncValue<List<Income>>> {
  final IncomeRepositoryImpl _repository;

  IncomeListNotifier(this._repository) : super(const AsyncValue.loading()) {
    getIncomes();
  }

  Future<void> getIncomes() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getIncomes());
  }

  Future<void> addIncome(Income income) async {
    final result = await AsyncValue.guard(() => _repository.createIncome(income));
    if (result.hasValue) {
        getIncomes();
    }
  }

  Future<void> updateIncome(Income income) async {
    final result = await AsyncValue.guard(() => _repository.updateIncome(income));
    if (result.hasValue) {
        getIncomes();
    }
  }

  Future<void> deleteIncome(String id) async {
    await _repository.deleteIncome(id);
     getIncomes();
  }
}
