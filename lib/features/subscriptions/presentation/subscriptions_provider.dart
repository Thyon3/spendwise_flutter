import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/network_providers.dart';
import '../domain/subscription.dart';
import '../infrastructure/subscriptions_api_service.dart';

final subscriptionsApiProvider = Provider<SubscriptionsApiService>(
  (ref) => SubscriptionsApiService(ref.watch(dioProvider)),
);

final subscriptionsProvider =
    AsyncNotifierProvider<SubscriptionsNotifier, List<Subscription>>(SubscriptionsNotifier.new);

class SubscriptionsNotifier extends AsyncNotifier<List<Subscription>> {
  @override
  Future<List<Subscription>> build() => ref.read(subscriptionsApiProvider).getAll();

  Future<void> create(Map<String, dynamic> data) async {
    final sub = await ref.read(subscriptionsApiProvider).create(data);
    state = AsyncData([...state.value ?? [], sub]);
  }

  Future<void> cancel(String id) async {
    await ref.read(subscriptionsApiProvider).cancel(id);
    ref.invalidateSelf();
  }

  Future<void> delete(String id) async {
    await ref.read(subscriptionsApiProvider).delete(id);
    state = AsyncData((state.value ?? []).where((s) => s.id != id).toList());
  }
}

final subscriptionAnalyticsProvider = FutureProvider<Map<String, dynamic>>((ref) {
  return ref.read(subscriptionsApiProvider).getAnalytics();
});
