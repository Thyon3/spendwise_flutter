import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/network_providers.dart';
import '../domain/payment_method.dart';
import '../infrastructure/payment_methods_api_service.dart';

final paymentMethodsApiProvider = Provider<PaymentMethodsApiService>(
  (ref) => PaymentMethodsApiService(ref.watch(dioProvider)),
);

final paymentMethodsProvider =
    AsyncNotifierProvider<PaymentMethodsNotifier, List<PaymentMethod>>(
        PaymentMethodsNotifier.new);

class PaymentMethodsNotifier extends AsyncNotifier<List<PaymentMethod>> {
  @override
  Future<List<PaymentMethod>> build() =>
      ref.read(paymentMethodsApiProvider).getAll();

  Future<void> create(Map<String, dynamic> data) async {
    final pm = await ref.read(paymentMethodsApiProvider).create(data);
    state = AsyncData([...state.value ?? [], pm]);
  }

  Future<void> delete(String id) async {
    await ref.read(paymentMethodsApiProvider).delete(id);
    state = AsyncData((state.value ?? []).where((p) => p.id != id).toList());
  }

  Future<void> setDefault(String id) async {
    final updated = await ref.read(paymentMethodsApiProvider).setDefault(id);
    state = AsyncData((state.value ?? []).map((p) {
      if (p.id == updated.id) return updated;
      return PaymentMethod(
        id: p.id, name: p.name, type: p.type,
        lastFourDigits: p.lastFourDigits,
        isDefault: false, isActive: p.isActive,
      );
    }).toList());
  }
}
