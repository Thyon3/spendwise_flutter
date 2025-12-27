import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/network_providers.dart';
import '../domain/investment.dart';
import '../infrastructure/investment_api_service.dart';

final investmentApiProvider = Provider<InvestmentApiService>(
  (ref) => InvestmentApiService(ref.watch(dioProvider)),
);

final investmentsProvider =
    AsyncNotifierProvider<InvestmentsNotifier, List<Investment>>(InvestmentsNotifier.new);

class InvestmentsNotifier extends AsyncNotifier<List<Investment>> {
  @override
  Future<List<Investment>> build() => ref.read(investmentApiProvider).getAll();

  Future<void> create(Map<String, dynamic> data) async {
    final inv = await ref.read(investmentApiProvider).create(data);
    state = AsyncData([...state.value ?? [], inv]);
  }

  Future<void> updatePrice(String id, double price) async {
    final updated = await ref.read(investmentApiProvider).updatePrice(id, price);
    state = AsyncData((state.value ?? []).map((i) => i.id == id ? updated : i).toList());
  }

  Future<void> delete(String id) async {
    await ref.read(investmentApiProvider).delete(id);
    state = AsyncData((state.value ?? []).where((i) => i.id != id).toList());
  }
}

final portfolioSummaryProvider = FutureProvider<Map<String, dynamic>>((ref) {
  return ref.read(investmentApiProvider).getPortfolio();
});
