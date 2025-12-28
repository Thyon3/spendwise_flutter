import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/subscription.dart';
import 'subscriptions_provider.dart';

class SubscriptionsScreen extends ConsumerWidget {
  const SubscriptionsScreen({super.key});

  static const _cycles = ['MONTHLY', 'YEARLY', 'WEEKLY'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subsAsync = ref.watch(subscriptionsProvider);
    final analyticsAsync = ref.watch(subscriptionAnalyticsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Subscriptions')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSheet(context, ref),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          analyticsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (analytics) => _AnalyticsBanner(analytics: analytics),
          ),
          Expanded(
            child: subsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (subs) {
                if (subs.isEmpty) return const Center(child: Text('No subscriptions tracked.'));
                final upcoming = subs.where((s) => s.isUpcoming && s.isActive).toList();
                final rest = subs.where((s) => !s.isUpcoming || !s.isActive).toList();
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (upcoming.isNotEmpty) ...[
                      const Text('Upcoming Renewals', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...upcoming.map((s) => _SubscriptionTile(sub: s, ref: ref)),
                      const Divider(height: 24),
                    ],
                    ...rest.map((s) => _SubscriptionTile(sub: s, ref: ref)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddSheet(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final providerCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    String selectedCycle = _cycles.first;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: StatefulBuilder(
          builder: (ctx, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Add Subscription', style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: providerCtrl, decoration: const InputDecoration(labelText: 'Provider', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: amountCtrl, decoration: const InputDecoration(labelText: 'Amount', border: OutlineInputBorder()), keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedCycle,
                decoration: const InputDecoration(labelText: 'Billing Cycle', border: OutlineInputBorder()),
                items: _cycles.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => selectedCycle = v!),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  final name = nameCtrl.text.trim();
                  final amount = double.tryParse(amountCtrl.text);
                  if (name.isEmpty || amount == null) return;
                  final now = DateTime.now();
                  final next = selectedCycle == 'YEARLY'
                      ? DateTime(now.year + 1, now.month, now.day)
                      : selectedCycle == 'WEEKLY'
                          ? now.add(const Duration(days: 7))
                          : DateTime(now.year, now.month + 1, now.day);
                  ref.read(subscriptionsProvider.notifier).create({
                    'name': name,
                    'provider': providerCtrl.text.trim().isEmpty ? name : providerCtrl.text.trim(),
                    'amount': amount,
                    'currency': 'USD',
                    'billingCycle': selectedCycle,
                    'startDate': now.toIso8601String(),
                    'nextBillingDate': next.toIso8601String(),
                  });
                  Navigator.pop(ctx);
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnalyticsBanner extends StatelessWidget {
  final Map<String, dynamic> analytics;
  const _AnalyticsBanner({required this.analytics});

  @override
  Widget build(BuildContext context) {
    final monthly = (analytics['monthlyTotal'] ?? 0.0) as num;
    final total = (analytics['total'] ?? 0) as num;
    final upcoming = (analytics['upcoming'] as List?)?.length ?? 0;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Stat(label: 'Monthly', value: '\$${monthly.toStringAsFixed(2)}'),
          _Stat(label: 'Active', value: '$total'),
          _Stat(label: 'Due Soon', value: '$upcoming'),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      );
}

class _SubscriptionTile extends StatelessWidget {
  final Subscription sub;
  final WidgetRef ref;
  const _SubscriptionTile({required this.sub, required this.ref});

  @override
  Widget build(BuildContext context) {
    final daysUntil = sub.nextBillingDate.difference(DateTime.now()).inDays;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(child: Text(sub.name[0].toUpperCase())),
        title: Text(sub.name),
        subtitle: Text('${sub.provider} · ${sub.billingCycle}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('${sub.currency} ${sub.amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(daysUntil == 0 ? 'Today' : 'in $daysUntil days', style: TextStyle(fontSize: 11, color: sub.isUpcoming ? Colors.orange : Colors.grey)),
          ],
        ),
        onLongPress: () => showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(sub.name),
            actions: [
              TextButton(onPressed: () { ref.read(subscriptionsProvider.notifier).cancel(sub.id); Navigator.pop(ctx); }, child: const Text('Cancel Sub', style: TextStyle(color: Colors.orange))),
              TextButton(onPressed: () { ref.read(subscriptionsProvider.notifier).delete(sub.id); Navigator.pop(ctx); }, child: const Text('Delete', style: TextStyle(color: Colors.red))),
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
            ],
          ),
        ),
      ),
    );
  }
}
