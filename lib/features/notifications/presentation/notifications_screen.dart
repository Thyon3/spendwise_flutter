import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/notification_item.dart';
import 'notifications_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifAsync = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'mark_all') ref.read(notificationsProvider.notifier).markAllAsRead();
              if (v == 'clear_read') ref.read(notificationsProvider.notifier).clearRead();
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'mark_all', child: Text('Mark all as read')),
              const PopupMenuItem(value: 'clear_read', child: Text('Clear read')),
            ],
          ),
        ],
      ),
      body: notifAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (notifications) => notifications.isEmpty
            ? const Center(child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.notifications_none, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('No notifications', style: TextStyle(color: Colors.grey)),
                ],
              ))
            : ListView.separated(
                itemCount: notifications.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) => _NotificationTile(
                  item: notifications[i],
                  onRead: () => ref.read(notificationsProvider.notifier).markAsRead(notifications[i].id),
                  onDelete: () => ref.read(notificationsProvider.notifier).delete(notifications[i].id),
                ),
              ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback onRead;
  final VoidCallback onDelete;

  const _NotificationTile({required this.item, required this.onRead, required this.onDelete});

  IconData get _icon {
    switch (item.type) {
      case 'BUDGET_ALERT': return Icons.warning_amber;
      case 'GOAL_ACHIEVED': return Icons.emoji_events;
      case 'RECURRING_REMINDER': return Icons.repeat;
      default: return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 16), child: const Icon(Icons.delete, color: Colors.white)),
      onDismissed: (_) => onDelete(),
      child: ListTile(
        tileColor: item.isRead ? null : theme.colorScheme.primaryContainer.withOpacity(0.3),
        leading: CircleAvatar(
          backgroundColor: item.isRead ? Colors.grey.shade200 : theme.colorScheme.primaryContainer,
          child: Icon(_icon, size: 20, color: item.isRead ? Colors.grey : theme.colorScheme.primary),
        ),
        title: Text(item.title, style: TextStyle(fontWeight: item.isRead ? FontWeight.normal : FontWeight.bold)),
        subtitle: Text(item.message, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: Text(_timeAgo(item.createdAt), style: theme.textTheme.bodySmall),
        onTap: item.isRead ? null : onRead,
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
