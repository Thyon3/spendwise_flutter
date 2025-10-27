import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/network_providers.dart';
import '../domain/notification_item.dart';
import '../infrastructure/notifications_api_service.dart';

final notificationsApiProvider = Provider<NotificationsApiService>(
  (ref) => NotificationsApiService(ref.watch(dioProvider)),
);

final notificationsProvider =
    AsyncNotifierProvider<NotificationsNotifier, List<NotificationItem>>(NotificationsNotifier.new);

class NotificationsNotifier extends AsyncNotifier<List<NotificationItem>> {
  @override
  Future<List<NotificationItem>> build() => ref.read(notificationsApiProvider).getAll();

  Future<void> markAsRead(String id) async {
    await ref.read(notificationsApiProvider).markAsRead(id);
    state = AsyncData((state.value ?? []).map((n) {
      if (n.id != id) return n;
      return NotificationItem(id: n.id, title: n.title, message: n.message, type: n.type, isRead: true, createdAt: n.createdAt, readAt: DateTime.now());
    }).toList());
  }

  Future<void> markAllAsRead() async {
    await ref.read(notificationsApiProvider).markAllAsRead();
    ref.invalidateSelf();
  }

  Future<void> delete(String id) async {
    await ref.read(notificationsApiProvider).delete(id);
    state = AsyncData((state.value ?? []).where((n) => n.id != id).toList());
  }

  Future<void> clearRead() async {
    await ref.read(notificationsApiProvider).clearRead();
    state = AsyncData((state.value ?? []).where((n) => !n.isRead).toList());
  }
}

final unreadCountProvider = FutureProvider<int>((ref) {
  return ref.read(notificationsApiProvider).getUnreadCount();
});
