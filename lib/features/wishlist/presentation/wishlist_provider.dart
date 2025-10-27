import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/network_providers.dart';
import '../domain/wishlist_item.dart';
import '../infrastructure/wishlist_api_service.dart';

final wishlistApiProvider = Provider<WishlistApiService>(
  (ref) => WishlistApiService(ref.watch(dioProvider)),
);

final wishlistProvider =
    AsyncNotifierProvider<WishlistNotifier, List<WishlistItem>>(WishlistNotifier.new);

class WishlistNotifier extends AsyncNotifier<List<WishlistItem>> {
  @override
  Future<List<WishlistItem>> build() => ref.read(wishlistApiProvider).getAll();

  Future<void> create(Map<String, dynamic> data) async {
    final item = await ref.read(wishlistApiProvider).create(data);
    state = AsyncData([...state.value ?? [], item]);
  }

  Future<void> markPurchased(String id) async {
    final updated = await ref.read(wishlistApiProvider).markPurchased(id);
    state = AsyncData((state.value ?? []).map((w) => w.id == id ? updated : w).toList());
  }

  Future<void> delete(String id) async {
    await ref.read(wishlistApiProvider).delete(id);
    state = AsyncData((state.value ?? []).where((w) => w.id != id).toList());
  }
}
