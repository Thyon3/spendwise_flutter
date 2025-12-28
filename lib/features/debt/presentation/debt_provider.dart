import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/network_providers.dart';
import '../domain/debt.dart';
import '../infrastructure/debt_api_service.dart';

final debtApiProvider = Provider<DebtApiService>(
  (ref) => DebtApiService(ref.watch(dioProvider)),
);

final debtsProvider = AsyncNotifierProvider<DebtsNotifier, List<Debt>>(DebtsNotifier.new);

class DebtsNotifier extends AsyncNotifier<List<Debt>> {
  @override
  Future<List<Debt>> build() => ref.read(debtApiProvider).getAll();

  Future<void> create(Map<String, dynamic> data) async {
    final debt = await ref.read(debtApiProvider).create(data);
    state = AsyncData([...state.value ?? [], debt]);
  }

  Future<void> addPayment(String debtId, Map<String, dynamic> data) async {
    await ref.read(debtApiProvider).addPayment(debtId, data);
    ref.invalidateSelf();
  }

  Future<void> delete(String id) async {
    await ref.read(debtApiProvider).delete(id);
    state = AsyncData((state.value ?? []).where((d) => d.id != id).toList());
  }
}

final debtSummaryProvider = FutureProvider<Map<String, dynamic>>((ref) {
  return ref.read(debtApiProvider).getSummary();
});
