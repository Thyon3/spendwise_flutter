import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/network_providers.dart';
import '../domain/savings_goal.dart';
import '../infrastructure/savings_goals_api_service.dart';

final savingsGoalsApiProvider = Provider<SavingsGoalsApiService>(
  (ref) => SavingsGoalsApiService(ref.watch(dioProvider)),
);

final savingsGoalsProvider =
    AsyncNotifierProvider<SavingsGoalsNotifier, List<SavingsGoal>>(SavingsGoalsNotifier.new);

class SavingsGoalsNotifier extends AsyncNotifier<List<SavingsGoal>> {
  @override
  Future<List<SavingsGoal>> build() => ref.read(savingsGoalsApiProvider).getAll();

  Future<void> create(Map<String, dynamic> data) async {
    final goal = await ref.read(savingsGoalsApiProvider).create(data);
    state = AsyncData([...state.value ?? [], goal]);
  }

  Future<void> contribute(String id, double amount) async {
    final updated = await ref.read(savingsGoalsApiProvider).contribute(id, amount);
    state = AsyncData((state.value ?? []).map((g) => g.id == id ? updated : g).toList());
  }

  Future<void> delete(String id) async {
    await ref.read(savingsGoalsApiProvider).delete(id);
    state = AsyncData((state.value ?? []).where((g) => g.id != id).toList());
  }
}
